//
//  ContentView.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/31/25.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		NavigationStack {
			List {
				NavigationLink("Zoom Image + Hero Transition") {
					ZoomImageView()
				}
				NavigationLink("3D Card Flip") {
					CardFlipView()
				}
				NavigationLink("Smooth Scroll + Parallax") {
					SmoothScrollView()
				}
				NavigationLink("Bounce Button") {
					BounceButtonDemo()
				}
				NavigationLink("Fireworks Burst") {
					FireworksBurstView()
				}
				NavigationLink("Morphing Shape Animation") {
					MultiShapeMorphingView()
				}
				NavigationLink("Page Curl") {
					PageCurlContentView()
				}
				NavigationLink("Fragmented Image") {
					if let uiImage = UIImage(named: "beach") {
						FragmentedImageView(image: uiImage)
					} else {
						Text("Image not found")
					}
				}
			}
		}
	}
}

struct BounceButtonDemo: View {
	var body: some View {
		ZStack {
			// Nền thử nghiệm phong cách hiện đại
			LinearGradient(colors: [Color.black, Color.gray.opacity(0.6)],
						   startPoint: .topLeading, endPoint: .bottomTrailing)
				.edgesIgnoringSafeArea(.all)

			VStack(spacing: 40) {
				PremiumBounceButton(action: {
					print("Luxury button tapped")
				}, label: {
					Label("ZARA STYLE", systemImage: "sparkles")
				}, theme: .luxury)

				PremiumBounceButton(action: {
					print("Neon button tapped")
				}, label: {
					Label("NIKE STYLE", systemImage: "bolt.fill")
				}, theme: .neon)

				PremiumBounceButton(action: {
					print("Shopee button tapped")
				}, label: {
					Label("SHOP NOW", systemImage: "bag.fill")
				}, theme: .shopping)
			}
		}
	}
}
