//
//  SwipeCardView.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/29/25.
//

import UIKit

class SwipeCardView: UIView {
	var onSwiped: ((SwipeDirection) -> Void)?

	enum SwipeDirection {
		case left
		case right
	}
	
	private let imageView = UIImageView()
	private let label = UILabel()
	
	private var originalCenter: CGPoint = .zero
	private let threshold: CGFloat = 100
	
	init(image: UIImage?, title: String) {
		super.init(frame: .zero)
		setupView(image: image, title: title)
		addGestureRecognizers()
	}
	
	private func setupView(image: UIImage?, title: String) {
		imageView.image = image
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		label.text = title
		label.textAlignment = .center
		label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		label.textColor = .white
		
		layer.cornerRadius = 16
		clipsToBounds = true
		backgroundColor = .lightGray

		addSubview(imageView)
		addSubview(label)
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: topAnchor),
			imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
			imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: trailingAnchor),

			label.heightAnchor.constraint(equalToConstant: 40),
			label.leadingAnchor.constraint(equalTo: leadingAnchor),
			label.trailingAnchor.constraint(equalTo: trailingAnchor),
			label.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}

	private func addGestureRecognizers() {
		let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
		self.addGestureRecognizer(pan)
	}

	@objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
		let translation = gesture.translation(in: self)
		let centerOffset = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y + translation.y)
		self.center = centerOffset

		let rotation = translation.x / 300
		self.transform = CGAffineTransform(rotationAngle: rotation)

		if gesture.state == .ended {
			if abs(translation.x) > threshold {
				let direction: SwipeDirection = translation.x > 0 ? .right : .left

				UIView.animate(withDuration: 0.3, animations: {
					self.center = CGPoint(x: self.center.x + 500 * (translation.x > 0 ? 1 : -1), y: self.center.y)
					self.alpha = 0
				}) { _ in
					self.removeFromSuperview()
					self.onSwiped?(direction) // 🔔 Gọi callback ở đây
				}
			} else {
				UIView.animate(withDuration: 0.3) {
					self.center = self.originalCenter
					self.transform = .identity
				}
			}
		}
	}

	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		self.originalCenter = self.center
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
