//
//  CoolTableViewCell.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 8/11/25.
//

import UIKit

protocol ItemsTableViewCellDelegate: AnyObject {
	func itemsTableViewCellDidTapEdit(_ cell: ItemsTableViewCell)
	func itemsTableViewCellDidTapDelete(_ cell: ItemsTableViewCell)
	func cellDidOpen(_ cell: ItemsTableViewCell) // Thêm hàm để báo cell mở swipe
}

class ItemsTableViewCell: UITableViewCell {
	static let identifier = "ItemsTableViewCell"
	
	weak var delegate: ItemsTableViewCellDelegate?

	private let actionWidth: CGFloat = 80
	private var panStartX: CGFloat = 0
	private var isOpen = false

	private let actionContainer = UIView()
	private let editButton = UIButton(type: .system)
	private let deleteButton = UIButton(type: .system)

	private let cardView: UIView = {
		let v = UIView()
		v.backgroundColor = .clear
		v.layer.cornerRadius = 16
		v.layer.shadowColor = UIColor.black.cgColor
		v.layer.shadowOpacity = 0.12
		v.layer.shadowOffset = CGSize(width: 0, height: 6)
		v.layer.shadowRadius = 12
		return v
	}()

	private let mainImageView: UIImageView = {
		let iv = UIImageView()
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		iv.layer.cornerRadius = 16
		return iv
	}()

	private let blurOverlay: UIVisualEffectView = {
		let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
		let blurView = UIVisualEffectView(effect: blurEffect)
		blurView.layer.cornerRadius = 16
		blurView.clipsToBounds = true
		return blurView
	}()

	private let titleLabel: UILabel = {
		let lbl = UILabel()
		lbl.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
		lbl.textColor = .white
		return lbl
	}()

	private let subtitleLabel: UILabel = {
		let lbl = UILabel()
		lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		lbl.textColor = UIColor.white.withAlphaComponent(0.85)
		lbl.numberOfLines = 2
		return lbl
	}()

	private let badgeView: UILabel = {
		let lbl = UILabel()
		lbl.font = UIFont.systemFont(ofSize: 12, weight: .medium)
		lbl.textColor = .white
		lbl.backgroundColor = UIColor.systemRed
		lbl.textAlignment = .center
		lbl.layer.cornerRadius = 10
		lbl.clipsToBounds = true
		return lbl
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		backgroundColor = .clear
		selectionStyle = .none

		actionContainer.backgroundColor = UIColor.systemGray.withAlphaComponent(0.15)
		contentView.addSubview(actionContainer)

		editButton.setTitle("Edit", for: .normal)
		editButton.setTitleColor(.white, for: .normal)
		editButton.backgroundColor = .systemOrange
		editButton.layer.cornerRadius = 8
		editButton.titleLabel?.font = .boldSystemFont(ofSize: 16)

		deleteButton.setTitle("Delete", for: .normal)
		deleteButton.setTitleColor(.white, for: .normal)
		deleteButton.backgroundColor = .systemRed
		deleteButton.layer.cornerRadius = 8
		deleteButton.titleLabel?.font = .boldSystemFont(ofSize: 16)

		actionContainer.addSubview(editButton)
		actionContainer.addSubview(deleteButton)

		contentView.addSubview(cardView)
		cardView.addSubview(mainImageView)
		cardView.addSubview(blurOverlay)
		blurOverlay.contentView.addSubview(titleLabel)
		blurOverlay.contentView.addSubview(subtitleLabel)
		cardView.addSubview(badgeView)

		let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
		pan.delegate = self
		cardView.addGestureRecognizer(pan)
		
		editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
		deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
	}

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	override func layoutSubviews() {
		super.layoutSubviews()
		let fullFrame = contentView.bounds.insetBy(dx: 16, dy: 8)

		actionContainer.frame = fullFrame
		cardView.frame = fullFrame

		mainImageView.frame = cardView.bounds

		let blurHeight: CGFloat = 70
		blurOverlay.frame = CGRect(
			x: 0,
			y: cardView.bounds.height - blurHeight,
			width: cardView.bounds.width,
			height: blurHeight
		)

		titleLabel.frame = CGRect(x: 12, y: 20, width: blurOverlay.bounds.width - 24, height: 24)
		subtitleLabel.frame = CGRect(x: 12, y: titleLabel.frame.maxY + 2, width: blurOverlay.bounds.width - 24, height: 20)
		badgeView.frame = CGRect(x: 12, y: 10, width: 50, height: 20)

		let btnHeight = (fullFrame.height - 12) / 2

		editButton.frame = CGRect(x: actionContainer.bounds.width - actionWidth, y: 4, width: actionWidth - 8, height: btnHeight - 4)
		deleteButton.frame = CGRect(x: actionContainer.bounds.width - actionWidth, y: btnHeight + 4, width: actionWidth - 8, height: btnHeight - 4)
	}

	func configure(image: UIImage?, title: String, subtitle: String, badge: String) {
		mainImageView.image = image
		titleLabel.text = title
		subtitleLabel.text = subtitle
		badgeView.text = badge
	}

	@objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
		let translation = gesture.translation(in: contentView)
		switch gesture.state {
		case .began:
			panStartX = cardView.transform.tx
		case .changed:
			var newX = panStartX + translation.x
			newX = min(0, max(newX, -actionWidth))
			cardView.transform = CGAffineTransform(translationX: newX, y: 0)
		case .ended, .cancelled:
			let velocity = gesture.velocity(in: contentView).x
			let currentX = cardView.transform.tx
			if velocity < -300 || currentX < -actionWidth / 2 {
				openActions(animated: true)
				delegate?.cellDidOpen(self)
			} else {
				closeActions(animated: true)
			}
		default:
			break
		}
	}

	func openActions(animated: Bool) {
		let animations = {
			self.cardView.transform = CGAffineTransform(translationX: -self.actionWidth, y: 0)
		}
		let completion: (Bool) -> Void = { _ in self.isOpen = true }
		if animated {
			UIView.animate(withDuration: 0.25,
						   delay: 0,
						   usingSpringWithDamping: 0.8,
						   initialSpringVelocity: 0.5,
						   options: [.curveEaseOut],
						   animations: animations,
						   completion: completion)
		} else {
			animations()
			completion(true)
		}
	}

	func closeActions(animated: Bool) {
		let animations = {
			self.cardView.transform = .identity
		}
		let completion: (Bool) -> Void = { _ in self.isOpen = false }
		if animated {
			UIView.animate(withDuration: 0.25,
						   delay: 0,
						   usingSpringWithDamping: 0.8,
						   initialSpringVelocity: 0.5,
						   options: [.curveEaseOut],
						   animations: animations,
						   completion: completion)
		} else {
			animations()
			completion(true)
		}
	}

	@objc private func editTapped() {
		delegate?.itemsTableViewCellDidTapEdit(self)
		closeActions(animated: true)
	}

	@objc private func deleteTapped() {
		delegate?.itemsTableViewCellDidTapDelete(self)
		closeActions(animated: true)
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		// Reset trạng thái đóng khi reuse để tránh hiển thị sai
		closeActions(animated: false)
	}

	// MARK: Gesture Recognizer Delegate
	override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
									shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		// Không nhận gesture đồng thời để tránh conflict với scroll
		return false
	}

	override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
			let velocity = panGesture.velocity(in: self)
			// Chỉ nhận gesture khi chuyển động ngang nhiều hơn dọc
			return abs(velocity.x) > abs(velocity.y)
		}
		return true
	}
}
