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
        
        overrideUserInterfaceStyle = .light
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

        
//        let xController = CompositionalController()
//        let xView = xController.view!
//
//        view.addSubview(xView)
//        addChild(xController)
//        xController.didMove(toParent: self)
//
//        xView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            xView.topAnchor.constraint(equalTo: view.topAnchor),
//            xView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            xView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            xView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
    }


}

