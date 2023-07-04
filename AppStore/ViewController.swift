//
//  ViewController.swift
//  AppStore
//
//  Created by Ajay Sarkate on 03/07/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tabBarController =  BaseTabBarController()
        let tabBarView = tabBarController.view!
        
        view.addSubview(tabBarView) //STEP 1
        addChild(tabBarController) // STEP 2
        tabBarController.didMove(toParent: self) //STEP 3
        
        NSLayoutConstraint.activate([
            tabBarView.topAnchor.constraint(equalTo: view.topAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }


}

