//
//  MainTabBarController.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/27/25.
//

import UIKit
import SideMenu

class MainTabBarController: UITabBarController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Setup slide menu
		let menu = SideMenuNavigationController(rootViewController: MenuViewController())
		menu.leftSide = true
		SideMenuManager.default.leftMenuNavigationController = menu
		SideMenuManager.default.addPanGestureToPresent(toView: view)
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "line.horizontal.3"),
			style: .plain,
			target: self,
			action: #selector(openMenu)
		)
	}

	@objc func openMenu() {
		if let menu = SideMenuManager.default.leftMenuNavigationController {
			present(menu, animated: true)
		}
	}
}
