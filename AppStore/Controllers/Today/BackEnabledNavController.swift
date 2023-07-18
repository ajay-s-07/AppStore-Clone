//
//  BackEnabledNavController.swift
//  AppStore
//
//  Created by Ajay Sarkate on 17/07/23.
//

import UIKit
// this is used in TodayController didSelectItemAt

class BackEnabledNavController: UINavigationController, UIGestureRecognizerDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1
    }
}
