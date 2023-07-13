//
//  AppsController.swift
//  AppStore
//
//  Created by Ajay Sarkate on 05/07/23.
//

import UIKit

class AppsPageController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "id"
    let headerId = "headerId"
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .black
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    // New screen comes when clicked on app group titles
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let redController = UIViewController()
//        redController.view.backgroundColor = .red
//        navigationController?.pushViewController(redController, animated: true)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        fetchData()
    }
    
    var socialApps = [SocialApp]()
    var editorChoice: AppGroup?
    var groups = [AppGroup]()
    
    fileprivate func fetchData() {
        Service.shared.fetchGames { (appGroup, err) in
            if let err = err{
                print("Failed to fetch games: ", err)
                return
            }
            
            self.editorChoice = appGroup
            if let group = appGroup {
                self.groups.append(group)
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        Service.shared.fetchGames2 { (appGroup, err) in
            if let err = err{
                print("Failed to fetch games: ", err)
                return
            }
            
            self.editorChoice = appGroup
            if let group = appGroup {
                self.groups.append(group)
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        Service.shared.fetchSocialApps { (apps, err) in

            self.socialApps = apps ?? []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppsPageHeader
        header.appHeaderHorizontalController.socialApps = self.socialApps
        header.appHeaderHorizontalController.collectionView.reloadData()
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsGroupCell
        cell.titleLabel.text = groups[indexPath.item].feed.title
        cell.horizontalController.appGroup = groups[indexPath.item]
        cell.horizontalController.collectionView.reloadData()
        // new screen when clicked on apps
        cell.horizontalController.didSelectHandler = { [weak self] feedResult in
            let controller = AppDetailController(appId: feedResult.id)
            controller.navigationItem.title = feedResult.name
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
    
}
