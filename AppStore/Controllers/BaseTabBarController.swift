//
//  BaseTabBarController.swift
//  AppStore
//
//  Created by Ajay Sarkate on 03/07/23.
//

import UIKit

class BaseTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let todayVC = UIViewController()
        todayVC.view.backgroundColor = .white
        todayVC.navigationItem.title = "Today"
        
        let todayNC = UINavigationController(rootViewController: todayVC)
        todayNC.tabBarItem.title = "Today"
        todayNC.tabBarItem.image = UIImage(named: "today_icon")
        todayNC.navigationBar.prefersLargeTitles = true
        
        let redVC = UIViewController()
        redVC.navigationItem.title = "APPS"
        
        let redNC = UINavigationController(rootViewController: redVC)
        redNC.tabBarItem.title = "Apps"
        redNC.tabBarItem.image = UIImage(systemName: "square.stack.3d.up.fill")
        redNC.navigationBar.prefersLargeTitles = true
        
        let blueVC = UIViewController()
        blueVC.navigationItem.title = "SEARCH"
        
        let blueNC = UINavigationController(rootViewController: blueVC)
        blueNC.tabBarItem.title = "Search"
        blueNC.tabBarItem.image = UIImage(named: "search")
        blueNC.navigationBar.prefersLargeTitles = true
        */
        
        
        
        
        viewControllers = [
            createNavController(viewController: MusicController(), title: "MUSIC", imageName: "music"),
            createNavController(viewController: TodayController(), title: "TODAY", imageName: "today_icon"),
            createNavController(viewController: AppsPageController(), title: "Apps", imageName: "apps"),
            createNavController(viewController: AppsSearchController(), title: "Search", imageName: "search"),
        ]
        
        tabBar.isTranslucent = false // up-down spaces
    }
    
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .white
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        
        return navController
    }
    
}
