//
//  MainTabBarController.swift
//  Pics
//
//  Created by factboii on 26.03.2020.
//  Copyright © 2020 factboii. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let photoImage = UIImage(systemName: "photo") else {return}
        viewControllers = [
            createNavigationController(vc: HomeController(), title: "Photos", image: photoImage)
            
        ]
        tabBar.barStyle = .black
        tabBar.isTranslucent = false
        tabBar.tintColor = .white
    }
    
    private func createNavigationController(vc: UIViewController, title: String, image: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image        
        vc.title = title
        vc.view.backgroundColor = .white
        return navController
    }
    
}
