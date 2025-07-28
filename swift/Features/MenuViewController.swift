//
//  MenuViewController.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/27/25.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	let menuItems = ["Home", "Profile", "Settings"]

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemGray6

		let tableView = UITableView(frame: view.bounds)
		tableView.delegate = self
		tableView.dataSource = self
		view.addSubview(tableView)
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return menuItems.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
		cell.textLabel?.text = menuItems[indexPath.row]
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let tabBarVC = presentingViewController as? MainTabBarController else { return }
		tabBarVC.selectedIndex = indexPath.row
		dismiss(animated: true, completion: nil)
	}
}
