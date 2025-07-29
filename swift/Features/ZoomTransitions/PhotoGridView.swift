//
//  PhotoGridView.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/28/25.
//

import SwiftUI

struct PhotoGridView: View {
	@Namespace private var transitionNamespace
	@State private var fullOption = true
	@State private var path = NavigationPath()
	let columns = [GridItem(.adaptive(minimum: 175))]
	var body: some View {
		NavigationStack (path: $path){
			Picker("Choose", selection: $fullOption) {
				Text("Full").tag(true)
				Text("Detail").tag(false)
			}
			ScrollView {
				LazyVGrid(columns: columns, spacing: 20) {
					ForEach(MyImage.samples) { photo in
						NavigationLink(value: photo) {
							Image(photo.imageName)
								.resizable()
								.scaledToFill()
								.frame(width: 175, height: 175)
								.clipShape(RoundedRectangle(cornerRadius: 10))
								.shadow(radius: 5)
								.matchedTransitionSource(id: photo, in: transitionNamespace)
						}
					}
				}
			}
			.navigationDestination(for: MyImage.self) { image in
				if fullOption {
					DetailView(image: image, onDismiss: {
					   path.removeLast()
				   })
						.navigationTransition(.zoom(sourceID: image, in: transitionNamespace))
				} else {
					DetailView2(image: image, transitionNamespace: transitionNamespace)
				}
			}
			.navigationTitle("My Images")
			.padding()
			.ignoresSafeArea(edges: .bottom)
		}
		
	}
}

#Preview {
	PhotoGridView()
}
