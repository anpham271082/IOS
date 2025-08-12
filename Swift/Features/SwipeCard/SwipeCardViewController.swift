//
//  SwipeCardViewController.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/29/25.
//

import UIKit

class SwipeCardViewController: UIViewController {
	let cardImages = ["CherryBlossom", "Hamburg", "LonsdaleQuay" , "Elbphilharmonie"]
	let cardTitles = ["CherryBlossom", "Hamburg", "LonsdaleQuay", "Elbphilharmonie"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setupCards()
	}

	private func setupCards() {
		let cardViews: [SwipeCardView] = cardTitles.reversed().enumerated().map { (index, title) in
			let card = SwipeCardView(image: UIImage(named: cardImages.reversed()[index]), title: title)
			card.frame = CGRect(x: 40, y: 150, width: view.frame.width - 80, height: 400)

			card.onSwiped = { direction in
				print("Card \(title) was swiped \(direction == .right ? "right" : "left")")
				
				card.removeFromSuperview()
				self.updateCardTransforms()

				// Nếu không còn card nào nữa
				if self.view.subviews.filter({ $0 is SwipeCardView }).isEmpty {
					self.showEndMessage()
				}
			}
			return card
		}

		cardViews.forEach { view.addSubview($0) }
		updateCardTransforms()
	}

	private func updateCardTransforms() {
		let cards = view.subviews.compactMap { $0 as? SwipeCardView }

		for (i, card) in cards.reversed().enumerated() {
			let scale = 1.0 - CGFloat(i) * 0.05
			let translateY = CGFloat(i) * 20
			card.layer.zPosition = CGFloat(100 - i)

			UIView.animate(withDuration: 0.3) {
				card.transform = CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: 0, y: translateY)
			}
		}
	}
	
	private func showEndMessage() {
		let alert = UIAlertController(title: "That's All!", message: "There are no more cards to view.", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default))
		present(alert, animated: true)
	}
}

