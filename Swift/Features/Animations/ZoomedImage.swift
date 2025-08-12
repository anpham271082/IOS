//
//  ZoomedImage.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/31/25.
//

import SwiftUI

struct ZoomedImage: View {
	let image: Image
	var namespace: Namespace.ID
	var onDismiss: () -> Void

	@State private var scale: CGFloat = 1.0
	@State private var offset: CGSize = .zero
	@GestureState private var isDragging = false
	@State private var backgroundOpacity: Double = 1.0
	@State private var cornerRadius: CGFloat = 16

	var body: some View {
		ZStack(alignment: .topTrailing) {
			// 1. Mờ nền có animation
			Color.black
				.opacity(backgroundOpacity)
				.ignoresSafeArea()
				.animation(.easeInOut(duration: 0.3), value: backgroundOpacity)

			// 2. Ảnh với hiệu ứng zoom, bo góc, shadow
			image
				.resizable()
				.aspectRatio(contentMode: .fit)
				.matchedGeometryEffect(id: "zoomedImage", in: namespace)
				.scaleEffect(scale)
				.offset(offset)
				.cornerRadius(cornerRadius)
				.shadow(color: Color.black.opacity(0.4), radius: 20, x: 0, y: 10)
				.gesture(
					SimultaneousGesture(
						DragGesture()
							.updating($isDragging) { _, state, _ in
								state = true
							}
							.onChanged { value in
								offset = value.translation
								backgroundOpacity = Double(max(0.2, 1 - abs(value.translation.height / 400)))
								cornerRadius = 32
							}
							.onEnded { value in
								if abs(value.translation.height) > 200 {
									onDismiss()
								} else {
									withAnimation(.spring()) {
										offset = .zero
										backgroundOpacity = 1
										cornerRadius = 16
									}
								}
							},
						MagnificationGesture()
							.onChanged { scale = $0 }
							.onEnded { _ in
								withAnimation(.spring()) {
									scale = 1.0
								}
							}
					)
				)
				.animation(.spring(response: 0.4, dampingFraction: 0.8), value: offset)

			// 3. Nút thoát
			Button {
				withAnimation(.easeInOut(duration: 0.3)) {
					onDismiss()
				}
			} label: {
				Image(systemName: "xmark.circle.fill")
					.font(.system(size: 36))
					.foregroundColor(.white)
					.padding()
					.shadow(radius: 10)
			}
		}
		.transition(.opacity)
	}
}
