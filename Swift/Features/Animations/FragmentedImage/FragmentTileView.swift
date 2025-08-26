//
//  FragmentTileView.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 8/2/25.
//

import SwiftUI

struct FragmentTileView: View {
	let image: UIImage
	let frame: CGRect
	@Binding var appear: Bool
	let row: Int
	let col: Int

	@State private var offset: CGSize = .zero
	@State private var opacity: Double = 0
	@State private var scale: CGFloat = 0.8
	@State private var blur: CGFloat = 8
	@State private var rotation: Double = 45

	var body: some View {
		Image(uiImage: image)
			.resizable()
			.frame(width: frame.width, height: frame.height)
			.position(x: frame.midX, y: frame.midY)
			.opacity(opacity)
			.offset(offset)
			.scaleEffect(scale)
			.blur(radius: blur)
			.rotation3DEffect(
				.degrees(rotation),
				axis: (x: 0.0, y: 1.0, z: 0.0)
			)
			.onAppear {
				animate(appear: appear)
			}
			.onChange(of: appear) { newValue in
				animate(appear: newValue)
			}
	}

	func animate(appear: Bool) {
		let randX = CGFloat.random(in: -120...120)
		let randY = CGFloat.random(in: -120...120)
		let delay = Double(row + col) * 0.04

		if appear {
			// Initial: mảnh nhỏ ở xa và mờ
			offset = CGSize(width: randX, height: randY)
			opacity = 0
			scale = 0.6
			blur = 8
			rotation = 90

			withAnimation(.interpolatingSpring(stiffness: 70, damping: 10).delay(delay)) {
				offset = .zero
				opacity = 1
				scale = 1
				blur = 0
				rotation = 0
			}
		} else {
			// Khi tan vỡ ra: bay ngẫu nhiên, thu nhỏ, mờ dần, xoay 3D
			withAnimation(.easeInOut(duration: 0.9).delay(delay)) {
				offset = CGSize(width: randX, height: randY)
				opacity = 0
				scale = 0.5
				blur = 10
				rotation = 90
			}
		}
	}
}
