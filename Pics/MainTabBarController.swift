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
		guard let photosImage = UIImage(systemName: "photo") else { return }
		guard let gridImage = UIImage(systemName: "rectangle.grid.2x2.fill") else { return }
		
		viewControllers = [
			createNavigationController(vc: CollectionsViewController(), title: "Collections", image: gridImage),
			createNavigationController(vc: HomeController(), title: "Photos", image: photosImage),
		]
		tabBar.barStyle = .black
		tabBar.isTranslucent = false
		tabBar.tintColor = .white
	}
	
	private func createNavigationController(vc: UIViewController, title: String, image: UIImage) -> UINavigationController {
		let navController = UINavigationController(rootViewController: vc)
		navController.tabBarItem.title = title
		navController.tabBarItem.image = image
		navController.navigationBar.tintColor = .black
		vc.title = title
		vc.view.backgroundColor = .white
		return navController
	}
	
}
