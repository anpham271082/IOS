//
//  PageFlipContainerView.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 8/1/25.
//

import SwiftUI
import UIKit

struct PageCurlController: UIViewControllerRepresentable {
	let pages: [UIViewController]

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	func makeUIViewController(context: Context) -> UIPageViewController {
		let controller = UIPageViewController(
			transitionStyle: .pageCurl,
			navigationOrientation: .horizontal,
			options: nil
		)
		controller.dataSource = context.coordinator
		controller.setViewControllers([pages[0]], direction: .forward, animated: true)
		return controller
	}

	func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {}

	class Coordinator: NSObject, UIPageViewControllerDataSource {
		var parent: PageCurlController

		init(_ parent: PageCurlController) {
			self.parent = parent
		}

		func pageViewController(_ pageViewController: UIPageViewController,
								viewControllerBefore viewController: UIViewController) -> UIViewController? {
			guard let index = parent.pages.firstIndex(of: viewController),
				  index > 0 else { return nil }
			return parent.pages[index - 1]
		}

		func pageViewController(_ pageViewController: UIPageViewController,
								viewControllerAfter viewController: UIViewController) -> UIViewController? {
			guard let index = parent.pages.firstIndex(of: viewController),
				  index < parent.pages.count - 1 else { return nil }
			return parent.pages[index + 1]
		}
	}
}
