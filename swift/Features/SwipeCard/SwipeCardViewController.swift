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
		for (index, title) in cardTitles.reversed().enumerated() {
			let card = SwipeCardView(image: UIImage(named: cardImages[index]), title: title)
			card.frame = CGRect(x: 40, y: 150, width: view.frame.width - 80, height: 400)
			card.onSwiped = { direction in
						print("Card \(title) was swiped \(direction == .right ? "right" : "left")")

						// Nếu đây là card cuối cùng:
						if self.view.subviews.filter({ $0 is SwipeCardView }).count == 0 {
							self.showEndMessage()
						}
					}
			view.addSubview(card)
		}
	}
	
	private func showEndMessage() {
		let alert = UIAlertController(title: "That's All!", message: "There are no more cards to view.", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default))
		present(alert, animated: true)
	}
}

