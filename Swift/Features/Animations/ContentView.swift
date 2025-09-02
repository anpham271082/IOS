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
	//DemoItem(title: "Bounce Button", destination: AnyView(BounceButtonDemo())),
	//DemoItem(title: "Fireworks Burst", destination: AnyView(FireworksBurstView())),
	DemoItem(title: "Morphing Shape Animation", destination: AnyView(MultiShapeMorphingView())),
	DemoItem(title: "Page Curl", destination: AnyView(PageCurlContentView())),
	DemoItem(title: "Fragmented Image", destination: {
		if let uiImage = UIImage(named: "beach") {
			return AnyView(FragmentedImageView(image: uiImage))
		} else {
			return AnyView(Text("Image not found"))
		}
	}()),
	DemoItem(title: "Ripple Effect", destination: AnyView(RippleView())),
	DemoItem(title: "Slide Image Carousel", destination: AnyView(SlideImageViewWrapper())),
	DemoItem(title: "Parallax Carousel Scroll", destination: AnyView(ParallaxCarouselScrollView())),
	DemoItem(title: "Scroll Progress Tracker", destination: AnyView(ScrollProgressTrackerView())),
	DemoItem(title: "Hacker Text Effect", destination: AnyView(HomeHackerTextEffectView())),
	DemoItem(title: "Particle Text", destination: AnyView(ParticleText())),
	DemoItem(title: "Shimmer Text", destination: AnyView(ShimmerText())),
	DemoItem(title: "Radial Menu", destination: AnyView(RadialMenu())),
	DemoItem(title: "Radial Menu", destination: AnyView(Animated3DDrawer())),
	
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





