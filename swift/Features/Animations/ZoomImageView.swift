//
//  ZoomImageView.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/31/25.
//

import SwiftUI
struct ZoomImageView: View {
	@State private var selectedImageURL: String? = nil
	@State private var selectedUIImage: Image? = nil
	@Namespace private var namespace

	let images = [
		"https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80",
		"https://images.unsplash.com/photo-1472214103451-9374bd1c798e?auto=format&fit=crop&w=800&q=80",
		"https://images.unsplash.com/photo-1500534623283-312aade485b7?auto=format&fit=crop&w=800&q=80",
		"https://images.unsplash.com/photo-1519985176271-adb1088fa94c?auto=format&fit=crop&w=800&q=80",
		"https://images.unsplash.com/photo-1503264116251-35a269479413?auto=format&fit=crop&w=800&q=80"
	]

	var body: some View {
		ScrollView {
			LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
				ForEach(images, id: \.self) { url in
					if selectedImageURL != url {
						AsyncImage(url: URL(string: url)) { phase in
							switch phase {
							case .empty:
								ProgressView()
									.frame(height: 180)
									.frame(maxWidth: .infinity)
							case .success(let image):
								image
									.resizable()
									.aspectRatio(contentMode: .fill)
									.frame(height: 180)
									.frame(maxWidth: .infinity)
									.clipShape(RoundedRectangle(cornerRadius: 16))
									.shadow(radius: 5)
									.matchedGeometryEffect(id: url, in: namespace)
									.onTapGesture {
										selectedUIImage = image
										withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
											selectedImageURL = url
										}
									}
							case .failure(_):
								Color.gray
									.frame(height: 180)
									.clipShape(RoundedRectangle(cornerRadius: 16))
							@unknown default:
								EmptyView()
							}
						}
					}
				}
			}
			.padding()
		}
		.overlay {
			if let selected = selectedImageURL, let cachedImage = selectedUIImage {
				ZoomedImage(image: cachedImage, namespace: namespace) {
					withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
						selectedImageURL = nil
						selectedUIImage = nil
					}
				}
			}
		}
		.navigationTitle("Zoom Image + Hero")
		.navigationBarTitleDisplayMode(.inline)
	}
}
