//
//  AppFullScreenController.swift
//  AppStore
//
//  Created by Ajay Sarkate on 13/07/23.
//

import UIKit

class AppFullScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dismissHandler: (() -> ())?
    
    var todayItem: TodayItem?
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
        
        if scrollView.contentOffset.y > 100 {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
                self.floatingContainerView.transform = .init(translationX: 0, y: -90)
            })
        } else {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
                self.floatingContainerView.transform = .identity
            })
        }
    }
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        
        setupCloseButton()
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.contentInsetAdjustmentBehavior = .never
        let height = UIApplication.shared.statusBarFrame.height
        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
        
        setupFloatingControls()
    }
    
    
    let floatingContainerView = UIView()
    
    fileprivate func setupFloatingControls() {

        floatingContainerView.layer.cornerRadius = 16
//        floatingContainerView.backgroundColor = .red
        view.addSubview(floatingContainerView)
        let bottomPadding = UIApplication.shared.statusBarFrame.height
        floatingContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: -70, right: 16), size: .init(width: 0, height: 70))
        
        let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        floatingContainerView.addSubview(blurVisualEffectView)
        blurVisualEffectView.layer.cornerRadius = 16
        blurVisualEffectView.fillSuperview()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        let imageView = UIImageView(cornerRadius: 16)
        imageView.image = todayItem?.imageName
        imageView.constrainHeight(constant: 48)
        imageView.constrainWidth(constant: 48)
        
        let getButton = UIButton(title: "GET")
        getButton.setTitleColor(.white, for: .normal)
        getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        getButton.backgroundColor = .darkGray
        getButton.layer.cornerRadius = 16
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant: 32)
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubviews: [
                UILabel(text: "Life Hack", font: .boldSystemFont(ofSize: 18)),
                UILabel(text: "Utilizing your time", font: .systemFont(ofSize: 16)),
            ], spacing: 4),
            getButton,
        ], customSpacing: 16)
        
        floatingContainerView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.alignment = .center
    }
    
    @objc fileprivate func handleTap() { // used in setupFloatingControls
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.floatingContainerView.transform = .init(translationX: 0, y: -70)
            
        })
    }
    
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "close_button"), for: .normal)
        return button
    }()
    
    fileprivate func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0 {
            let headerCell = AppFullScreenHeaderCell()
            closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
            headerCell.todayCell.todayItem = todayItem
            headerCell.todayCell.layer.cornerRadius = 0
            headerCell.clipsToBounds = true
            return headerCell
        }
        
        let cell = AppFullScreenDescriptionCell()
        return cell
    }
    
    @objc func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return TodayController.cellSize
        }
        return UITableView.automaticDimension
    }
    
}
