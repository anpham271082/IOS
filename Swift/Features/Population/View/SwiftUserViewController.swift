//
//  SwfitUserController.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/17/25.
//

import UIKit

class SwiftUserViewController: UIViewController {

	private let tableView = UITableView()
	private var users: [SwiftUserModel] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Users"
		view.backgroundColor = .systemGroupedBackground
		setupTableView()
		users = SwiftUserModel.mockList()
	}

	private func setupTableView() {
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])

		tableView.register(SwiftUserCell.self, forCellReuseIdentifier: "SwiftUserCell")
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		tableView.rowHeight = 72
	}
}

extension SwiftUserViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		users.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let user = users[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "SwiftUserCell", for: indexPath) as! SwiftUserCell
		cell.configure(with: user)
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let user = users[indexPath.row]
		print("Tapped: \(user.name)")
	}
}
