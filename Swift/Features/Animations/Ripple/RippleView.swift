//
//  RippleView.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 8/12/25.
//
import SwiftUI
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
