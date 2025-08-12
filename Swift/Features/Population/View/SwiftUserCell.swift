//
//  swfitUserCell.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/17/25.
//

import UIKit

class SwiftUserCell: UITableViewCell {

	private let cardView = UIView()
	private let avatarView = UIImageView()
	private let nameLabel = UILabel()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupLayout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupLayout() {
		selectionStyle = .none
		backgroundColor = .clear
		contentView.backgroundColor = .clear

		// Card styling
		cardView.backgroundColor = .systemBackground
		cardView.layer.cornerRadius = 12
		cardView.layer.shadowColor = UIColor.black.cgColor
		cardView.layer.shadowOpacity = 0.1
		cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
		cardView.layer.shadowRadius = 4

		avatarView.tintColor = .systemBlue
		avatarView.contentMode = .scaleAspectFit

		nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
		nameLabel.textColor = .label

		// Add views
		cardView.addSubview(avatarView)
		cardView.addSubview(nameLabel)
		contentView.addSubview(cardView)

		// Layout
		cardView.translatesAutoresizingMaskIntoConstraints = false
		avatarView.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

			avatarView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
			avatarView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
			avatarView.widthAnchor.constraint(equalToConstant: 32),
			avatarView.heightAnchor.constraint(equalToConstant: 32),

			nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
			nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
			nameLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
		])
	}

	func configure(with user: SwiftUserModel) {
		avatarView.image = UIImage(systemName: user.avatarSystemName)
		nameLabel.text = user.name
	}
}
