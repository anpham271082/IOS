//
//  ContentView.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/31/25.
//

import SwiftUI
struct DemoItem: Identifiable {
	let id = UUID()
	let title: String
	let destination: AnyView
}
let demoItems: [DemoItem] = [
	DemoItem(title: "Zoom Image + Hero Transition", destination: AnyView(ZoomImageView())),
	DemoItem(title: "3D Card Flip", destination: AnyView(CardFlipView())),
	DemoItem(title: "Smooth Scroll + Parallax", destination: AnyView(SmoothScrollView())),
	DemoItem(title: "Bounce Button", destination: AnyView(BounceButtonDemo())),
	DemoItem(title: "Fireworks Burst", destination: AnyView(FireworksBurstView())),
	DemoItem(title: "Morphing Shape Animation", destination: AnyView(MultiShapeMorphingView())),
	DemoItem(title: "Page Curl", destination: AnyView(PageCurlContentView())),
	DemoItem(title: "Fragmented Image", destination: {
		if let uiImage = UIImage(named: "beach") {
			return AnyView(FragmentedImageView(image: uiImage))
		} else {
			return AnyView(Text("Image not found"))
		}
	}()),
	DemoItem(title: "Ripple Effect", destination: AnyView(RippleView()))
]

struct ContentView: View {
	var body: some View {
		NavigationStack {
			List(demoItems) { item in
				NavigationLink(item.title) {
					item.destination
				}
			}
			.navigationTitle("Demo Animations")
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


struct RippleView: View {
	@State var counter: Int = 0
	@State var origin: CGPoint = .init(x: 0.5, y: 0.5)

	var body: some View {
		VStack {
			Image("Strasbourg")
				.resizable()
				.aspectRatio(contentMode: .fill) // Fill full view
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
				.overlay(
					Text("Ripple Effect")
						.font(.largeTitle.bold())
						.foregroundColor(.white)
						.shadow(radius: 5)
						.padding(),
					alignment: .bottom
				)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.blue)
		.cornerRadius(30)
		.onPressingChanged { point in
			if let point {
				origin = point
				counter += 1
			}
		}
		.modifier(RippleEffect(at: origin, trigger: counter))
		.padding()
	}
}
