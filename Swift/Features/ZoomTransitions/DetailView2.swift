//
//  DetailView2.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/28/25.
//


import SwiftUI

struct DetailView2: View {
	let image: MyImage
	let transitionNamespace: Namespace.ID
	@State private var showFull = false
	var body: some View {
		VStack {
			Image(image.imageName)
				.resizable()
				.scaledToFit()
				.frame(maxWidth: .infinity)
				.clipShape(RoundedRectangle(cornerRadius: 20))
				.shadow(radius: 10)
				.matchedTransitionSource(id: image, in: transitionNamespace)
				.onTapGesture {
					showFull.toggle()
				}
				.fullScreenCover(isPresented: $showFull) {
					NavigationStack {
						DetailView(image: image, onDismiss: {
										// Với preview, bạn có thể để trống hoặc in ra gì đó
							print("Dismiss called")
						})
					}
						.navigationTransition(.zoom(sourceID: image, in: transitionNamespace))
				}
			Text(image.name)
				.font(.title)
			Text(image.info)
			Spacer()
		}
		.navigationTransition(.zoom(sourceID: image, in: transitionNamespace))
		.padding()
	}
}

@available(iOS 17.0, *)
#Preview {
	@Previewable @Namespace var transitionNamespace   
	DetailView2(image: MyImage.samples[6],
				transitionNamespace: transitionNamespace)
}
