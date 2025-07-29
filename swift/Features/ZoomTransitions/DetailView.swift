//
//  DetailView.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/28/25.
//

import SwiftUI

struct DetailView: View {
	//@Environment(\.dismiss) private var dismiss
	let image: MyImage
	let onDismiss: () -> Void
	var body: some View {
		Image(image.imageName)
			.resizable()
			.scaledToFill()
			.ignoresSafeArea()
			.navigationBarBackButtonHidden(true)
			.toolbar {
				Button {
					onDismiss()
					//dismiss()
				} label: {
					Image(systemName: "xmark.circle.fill")
						.font(.title)
						.foregroundStyle(.white)
				}
			}
	}
}

#Preview {
	NavigationStack {
		DetailView(image: MyImage.samples[0], onDismiss: {
			print("Dismiss called")
		})
	}
}
