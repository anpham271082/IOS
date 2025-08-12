//
//  FragmentedImageView.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 8/2/25.
//
import SwiftUI
struct FragmentedImageView: View {
	let image: UIImage
	let rows: Int = 8
	let columns: Int = 8

	@State private var tiles: [Tile] = []
	@State private var isAppearing = true
	@State private var isVisible = true

	var body: some View {
		ZStack {
			if isVisible {
				GeometryReader { geo in
					let tileWidth = geo.size.width / CGFloat(columns)
					let tileHeight = geo.size.height / CGFloat(rows)

					ZStack {
						ForEach(tiles) { tile in
							FragmentTileView(
								image: tile.image,
								frame: CGRect(
									x: tile.col * tileWidth,
									y: tile.row * tileHeight,
									width: tileWidth,
									height: tileHeight
								),
								appear: $isAppearing,
								row: Int(tile.row),
								col: Int(tile.col)
							)
						}
					}
					.onAppear {
						createTiles(in: geo.size)
						withAnimation(.easeOut(duration: 1.2)) {
							isAppearing = true
						}
					}
				}
				.onTapGesture {
					withAnimation {
						isAppearing = false
					}

					DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
						isVisible = false
					}
				}
			} else {
				// Khi ảnh biến mất, show nút hiện lại
				VStack {
					Text("Image disappeared")
						.font(.title2)
						.padding(.bottom, 20)

					Button(action: {
						resetAnimation()
					}) {
						Text("Show Image Again")
							.font(.headline)
							.padding()
							.background(Color.blue)
							.foregroundColor(.white)
							.cornerRadius(12)
							.shadow(radius: 8)
					}
				}
				.transition(.opacity)
			}
		}
		.frame(width: 350, height: 300)
		.navigationTitle("Fragmented Image")
		.navigationBarTitleDisplayMode(.inline)
		.animation(.default, value: isVisible)
	}

	func resetAnimation() {
		// Hiện lại hình ảnh với animation
		isVisible = true
		isAppearing = false

		// delay 1 frame để đảm bảo onAppear gọi lại animation
		DispatchQueue.main.async {
			withAnimation(.easeOut(duration: 1.2)) {
				isAppearing = true
			}
		}
	}

	func createTiles(in size: CGSize) {
		let tileWidth = size.width / CGFloat(columns)
		let tileHeight = size.height / CGFloat(rows)

		guard let cgImage = image.cgImage else { return }

		var result: [Tile] = []

		for row in 0..<rows {
			for col in 0..<columns {
				let x = CGFloat(col) * tileWidth
				let y = CGFloat(row) * tileHeight
				let width = tileWidth
				let height = tileHeight

				let scale = image.scale
				let cropRect = CGRect(x: x * scale,
									  y: y * scale,
									  width: width * scale,
									  height: height * scale)

				if let tileCGImage = cgImage.cropping(to: cropRect) {
					let tileImage = UIImage(cgImage: tileCGImage, scale: scale, orientation: image.imageOrientation)
					result.append(Tile(id: UUID(), image: tileImage, row: CGFloat(row), col: CGFloat(col)))
				}
			}
		}

		tiles = result
	}
}

struct Tile: Identifiable {
	let id: UUID
	let image: UIImage
	let row: CGFloat
	let col: CGFloat
}
