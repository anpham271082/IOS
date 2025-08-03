//
//  MenuViewController.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/27/25.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	let menuItems: [(title: String, icon: String)] = [
		("Home", "house.fill"),
		("Profile", "person.crop.circle"),
		("Settings", "gearshape.fill")
	]

	private let tableView = UITableView(frame: .zero, style: .plain)

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.gray

		setupTableView()
	}

	private func setupTableView() {
		tableView.frame = view.bounds
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
		tableView.rowHeight = 60
		tableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")

		view.addSubview(tableView)
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return menuItems.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as? MenuCell else {
			return UITableViewCell()
		}
		let item = menuItems[indexPath.row]
		cell.configure(title: item.title, iconName: item.icon)
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		if let cell = tableView.cellForRow(at: indexPath) {
			UIView.animate(withDuration: 0.2,
						   animations: {
				cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
			}, completion: { _ in
				UIView.animate(withDuration: 0.2) {
					cell.transform = .identity
				}
			})
		}

		// Gọi action hoặc chuyển tab ở đây nếu muốn
		dismiss(animated: true, completion: nil)
	}
}
class MenuCell: UITableViewCell {

	private let iconImageView = UIImageView()
	private let titleLabel = UILabel()
	private let containerView = UIView()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(title: String, iconName: String) {
		titleLabel.text = title
		iconImageView.image = UIImage(systemName: iconName)
	}

	private func setupViews() {
		backgroundColor = .clear
		selectionStyle = .none

		containerView.backgroundColor = .white
		containerView.layer.cornerRadius = 12
		containerView.layer.shadowColor = UIColor.black.cgColor
		containerView.layer.shadowOpacity = 0.1
		containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
		containerView.layer.shadowRadius = 4

		iconImageView.tintColor = .systemBlue
		iconImageView.contentMode = .scaleAspectFit

		titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
		titleLabel.textColor = .darkGray

		containerView.addSubview(iconImageView)
		containerView.addSubview(titleLabel)
		contentView.addSubview(containerView)

		containerView.translatesAutoresizingMaskIntoConstraints = false
		iconImageView.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

			iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
			iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
			iconImageView.widthAnchor.constraint(equalToConstant: 24),
			iconImageView.heightAnchor.constraint(equalToConstant: 24),

			titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
			titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
		])
	}
}
