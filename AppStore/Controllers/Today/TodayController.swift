//
//  TodayController.swift
//  AppStore
//
//  Created by Ajay Sarkate on 13/07/23.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    fileprivate let multipleAppCellId = "multipleAppCellId"
    
//    let items = [
//        TodayItem.init(category: "LIFE HACK", title: "Utilize your Time", imageName: UIImage(named: "garden")!, desription: "All the tool and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .single),
//
//        TodayItem.init(category: "THE SECOND CELL", title: "Test-Drive these Carplay Apps", imageName: UIImage(named: "garden")!, desription: "", backgroundColor: .white, cellType: .multiple),
//
//        TodayItem.init(category: "HOLIDAYS", title: "Travel with Budget", imageName: UIImage(named: "star")!, desription: "All the tool and apps you need to intelligently organize your life the right way.", backgroundColor: UIColor(named: "HolidaysItemColor2") ?? .white, cellType: .single),
//
//        TodayItem.init(category: "THE DAILY LIST", title: "Test-Drive these Carplay Apps", imageName: UIImage(named: "garden")!, desription: "", backgroundColor: .white, cellType: .multiple),
//    ]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.backgroundColor = UIColor(named: "TodayControllerColor")
        
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
        
        
        
    }
    
    fileprivate func fetchData() {
        // dispatch group
        
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
                TodayItem.init(category: "THE GAMES", title: games?.feed.title ?? "", imageName: UIImage(named: "garden")!, desription: "", backgroundColor: .white, cellType: .multiple, apps: games?.feed.results ?? []),
                
                TodayItem.init(category: "THE GAMES 2", title: games2?.feed.title ?? "", imageName: UIImage(named: "garden")!, desription: "", backgroundColor: .white, cellType: .multiple, apps: games2?.feed.results ?? []),
                
                TodayItem.init(category: "LIFE HACK", title: "Utilize your Time", imageName: UIImage(named: "garden")!, desription: "All the tool and apps you need to intelligently organize your life the right way.", backgroundColor: .white, cellType: .single, apps: []),
                
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
        
        if items[indexPath.item].cellType == .multiple {
            let fullController = TodayMultipleAppsController(mode: .fullscreen)
            fullController.modalPresentationStyle = .fullScreen // full screen
            fullController.results = self.items[indexPath.item].apps
            
            let nav = BackEnabledNavController(rootViewController: fullController)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
            return
        }
        
        let appFullScreenController = AppFullScreenController()
        appFullScreenController.todayItem = items[indexPath.row]
        appFullScreenController.dismissHandler = {
            self.handleRemoveRedView()
        }
        
        let fullScreenView = appFullScreenController.view!
//        fullScreenView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemoveRedView)))
        view.addSubview(fullScreenView)
        
        addChild(appFullScreenController)
        
        self.appFullScreenController = appFullScreenController
        
        self.collectionView.isUserInteractionEnabled = false
        
        guard let cell = collectionView.cellForItem(at: indexPath) else{ return }
        
        // absolute coordinates of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.startingFrame = startingFrame
        
//        redView.frame = startingFrame
        
        fullScreenView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = fullScreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leadingConstraint = fullScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
        widthConstraint = fullScreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = fullScreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)

        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach({$0?.isActive = true})
        
        self.view.layoutIfNeeded()
        fullScreenView.layer.cornerRadius = 16
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: { [self] in
            
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
    
    
    @objc func handleRemoveRedView() {
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
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
