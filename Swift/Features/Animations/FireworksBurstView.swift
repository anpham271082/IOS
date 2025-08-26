//
//  FireworksBurstView.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/31/25.
//

import SwiftUI

struct FireworksBurstView: View {
	@State private var burstID = UUID() // Đổi ID để trigger lại mỗi lần
	let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

	var body: some View {
		ZStack {
			RadialGradient(
				gradient: Gradient(colors: [Color(red: 0.3, green: 0.3, blue: 0.3), Color(red: 0.05, green: 0.05, blue: 0.1)]),
				center: .center,
				startRadius: 2,
				endRadius: 500
			)
			.ignoresSafeArea()

			FireworksBurst(id: burstID)
				.transition(.opacity)
				.animation(.easeInOut(duration: 0.3), value: burstID)
		}
		.onReceive(timer) { _ in
			burstID = UUID() // Trigger burst lại
		}
		.navigationTitle("Fireworks Burst")
		.navigationBarTitleDisplayMode(.inline)
	}
}

struct FireworksBurst: View {
	let id: UUID
	let particlesCount = 40

	var body: some View {
		ZStack {
			ForEach(0..<particlesCount, id: \.self) { i in
				FireworkParticle(angle: Double(i) / Double(particlesCount) * 360)
					.blendMode(.screen)
			}
		}
		.id(id) // Cho phép view reset lại
	}
}

struct FireworkParticle: View {
	let angle: Double
	@State private var scale: CGFloat = 0.2
	@State private var opacity: Double = 1
	@State private var offsetDistance: CGFloat = 0

	private let maxDistance: CGFloat = CGFloat.random(in: 120...200)
	private let animationDuration: Double = Double.random(in: 1.0...1.6)

	private var color: Color {
		Color(hue: angle / 360, saturation: 1, brightness: 1)
	}

	var body: some View {
		Circle()
			.fill(color)
			.frame(width: 6, height: 6)
			.shadow(color: color.opacity(0.8), radius: 8)
			.blur(radius: 0.3)
			.offset(x: 0, y: -offsetDistance)
			.rotationEffect(.degrees(angle))
			.scaleEffect(scale)
			.opacity(opacity)
			.onAppear {
				animate()
			}
	}

	func animate() {
		scale = 0.2
		offsetDistance = 0
		opacity = 1

		withAnimation(Animation.easeOut(duration: animationDuration)) {
			scale = CGFloat.random(in: 0.8...1.3)
			offsetDistance = maxDistance
			opacity = 0
		}
	}
}
