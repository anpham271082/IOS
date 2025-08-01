//
//  UntitlAnimationsed.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/31/25.
//
import SwiftUI
class AnimationsViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white

		// Tạo UIHostingController chứa MyView
		let mySwiftUIView = ContentView()
		let hostingController = UIHostingController(rootView: mySwiftUIView)

		// Thêm hostingController như một child
		addChild(hostingController)
		hostingController.view.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(hostingController.view)

		// Thiết lập constraints cho hostingController.view (full screen hoặc theo ý bạn)
		NSLayoutConstraint.activate([
			hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
			hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])

		hostingController.didMove(toParent: self)
	}
}
