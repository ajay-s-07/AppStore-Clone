//
//  TodayController.swift
//  AppStore
//
//  Created by Ajay Sarkate on 13/07/23.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    fileprivate let cellId = "cellId"
    fileprivate let multipleAppCellId = "multipleAppCellId"
    
    var items = [TodayItem]()
    
    let  activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .black
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        
        return aiv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        
        fetchData()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.backgroundColor = UIColor(named: "TodayControllerColor")
        
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
        
    }
    
    fileprivate func fetchData() {
        
        let dispatchGroup = DispatchGroup()
        
        var games: AppGroup?
        var games2: AppGroup?
        
        dispatchGroup.enter()
        Service.shared.fetchGames { appGroup, err in
            games = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchGames2 { appGroup, err in
            games2 = appGroup
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print("finished fetching")
            self.activityIndicatorView.stopAnimating()
            
            self.items = [
                TodayItem.init(category: "LIFE HACK", title: "Utilize your Time", imageName: UIImage(named: "garden")!, desription: "All the tool and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .single, apps: []),
                
                TodayItem.init(category: "THE GAMES", title: games?.feed.title ?? "", imageName: UIImage(named: "garden")!, desription: "", backgroundColor: .white, cellType: .multiple, apps: games?.feed.results ?? []),
                
                TodayItem.init(category: "THE GAMES 2", title: games2?.feed.title ?? "", imageName: UIImage(named: "garden")!, desription: "", backgroundColor: .white, cellType: .multiple, apps: games2?.feed.results ?? []),
                
                TodayItem.init(category: "HOLIDAYS", title: "Travel with Budget", imageName: UIImage(named: "star")!, desription: "All the tool and apps you need to intelligently organize your life the right way.", backgroundColor: UIColor(named: "HolidaysItemColor2") ?? .white, cellType: .single, apps: []),
            ]
            
            self.collectionView.reloadData()
        }
    }
    
    
    var appFullScreenController: AppFullScreenController! // latest
    
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch items[indexPath.item].cellType {
        case .multiple:
            showDailyListFullscreen(indexPath)
        default:
            showSingleAppFullscreen(indexPath: indexPath)
        }
        
    }
    
    fileprivate func showDailyListFullscreen(_ indexPath: IndexPath) {
        let fullController = TodayMultipleAppsController(mode: .fullscreen)
        fullController.modalPresentationStyle = .fullScreen // full screen
        fullController.results = self.items[indexPath.item].apps
        
        let nav = BackEnabledNavController(rootViewController: fullController)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
        return
    }
    
    fileprivate func showSingleAppFullscreen(indexPath: IndexPath) {
        // 1
        setupSingleAppFullscreen(indexPath)
         
        // 2 setup fullscreen in its starting position
        setupStartingPosition(indexPath: indexPath)
        
        // 3 begin the fullscreen animation
        beginAnimationAppFullscreen()
        
    }
    
    fileprivate func setupSingleAppFullscreen(_ indexPath: IndexPath) {
        let appFullScreenController = AppFullScreenController()
        appFullScreenController.todayItem = items[indexPath.row]
        
        appFullScreenController.dismissHandler = {
            self.handleAppFullscreenDismissal()
        }
        self.appFullScreenController = appFullScreenController
        appFullScreenController.view.layer.cornerRadius = 16
        
        // 1 setup our pan gesture
        let gesture  = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate = self
        appFullScreenController.view.addGestureRecognizer(gesture)
        
        // 2 add a blue effect view
        
        // 3 not to interfere with our UITableView scrolling
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    var appFullscreenBeginOffset: CGFloat = 0
    
    @objc fileprivate func handleDrag(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .began {
            appFullscreenBeginOffset = appFullScreenController.tableView.contentOffset.y
        }
        if appFullScreenController.tableView.contentOffset.y > 0 {
            return
        }
        
        let translationY = gesture.translation(in: appFullScreenController.view).y
        
        if gesture.state == .changed {
            if translationY > 0 {
                let trueOffset = translationY - appFullscreenBeginOffset
                var scale = 1 - trueOffset / 1500
                scale = min(scale, 1)
                scale = max(0.8, scale)
                let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
                self.appFullScreenController.view.transform = transform
            }
        }
        if gesture.state == .ended {
            if translationY > 0 {
                handleAppFullscreenDismissal()
            }
        }
    }
    
    
    fileprivate func setupStartingPosition(indexPath: IndexPath) {
        let fullScreenView = appFullScreenController.view!
        // fullScreenView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemoveRedView)))
        view.addSubview(fullScreenView)
        
        addChild(appFullScreenController)
        
        self.collectionView.isUserInteractionEnabled = false
        
        guard let cell = collectionView.cellForItem(at: indexPath) else{ return }
        // absolute coordinates of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.startingFrame = startingFrame
        
        fullScreenView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = fullScreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraint = fullScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
        widthConstraint = fullScreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = fullScreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)

        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach({$0?.isActive = true})
        
        self.view.layoutIfNeeded()
    }
    
    fileprivate func beginAnimationAppFullscreen() {
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: { [self] in
            
            self.blurVisualEffectView.alpha = 1
            
            self.topConstraint?.constant = 0
            self.leadingConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.superview?.frame.height ?? 0
            
            self.view.layoutIfNeeded()
            
            // tabbar goes out
            self.tabBarController?.tabBar.frame.origin.y += 100
            
            guard let cell = self.appFullScreenController.tableView.cellForRow(at: [0,0]) as? AppFullScreenHeaderCell else { return }
            
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
            

        }, completion: nil)
    }
    
    
    var startingFrame: CGRect?
    
    
    @objc func handleAppFullscreenDismissal() {
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.blurVisualEffectView.alpha = 0
            self.appFullScreenController.view.transform = .identity
            
            self.appFullScreenController.tableView.contentOffset = .zero
            
//            gesture.view?.frame = self.startingFrame ?? .zero
            
            guard let startingFrame = self.startingFrame else { return }
            
            self.topConstraint?.constant = startingFrame.origin.y
            self.leadingConstraint?.constant = startingFrame.origin.x
            self.widthConstraint?.constant = startingFrame.width
            self.heightConstraint?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.frame.origin.y -= 100
            
            guard let cell = self.appFullScreenController.tableView.cellForRow(at: [0,0]) as? AppFullScreenHeaderCell else { return }
            // these are used when we come back again from full screen to today controller, button, floatingContainer still visible for some seconds. By using alpha = 0, it gets disappear immidiately.
            self.appFullScreenController.closeButton.alpha = 0
            self.appFullScreenController.floatingContainerView.alpha = 0
            cell.todayCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
            
        }, completion: { _ in
            self.appFullScreenController.view.removeFromSuperview()
            self.appFullScreenController?.removeFromParent() // latest
            self.collectionView.isUserInteractionEnabled = true
        })
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = items[indexPath.item].cellType.rawValue
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
        cell.todayItem = items[indexPath.item]
        
        (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
        
//        if let cell = cell as? TodayCell {
//            cell.todayItem = items[indexPath.item]
//        }
//        else if let cell = cell as? TodayMultipleAppCell {
//            cell.todayItem = items[indexPath.item]
//        }
        
        return cell
    }
    
    @objc fileprivate func handleMultipleAppsTap(gesture: UIGestureRecognizer) {

        let collectionView = gesture.view

        var superview = collectionView?.superview

        while superview != nil {
            if let cell = superview as? TodayMultipleAppCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }

                let fullController = TodayMultipleAppsController(mode: .fullscreen)
                fullController.results = self.items[indexPath.item].apps
                fullController.modalPresentationStyle = .fullScreen
                
                let nav = BackEnabledNavController(rootViewController: fullController)
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: true)
                
                return
            }
            superview = superview?.superview
        }

    }
    
    
    static let cellSize: CGFloat = 500
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: TodayController.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
}
