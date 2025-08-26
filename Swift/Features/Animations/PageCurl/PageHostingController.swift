//
//  PageHostingController.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 8/1/25.
//

import SwiftUI

class PageHostingController<Content: View>: UIHostingController<Content> {
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .clear
	}
}
