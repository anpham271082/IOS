//
//  ParticleText.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 8/25/25.
//

import SwiftUI
import SwiftUI_Shimmer

struct ShimmerText: View {
	@State private var animate = false
	var body: some View {
		ZStack {
			Color.black.ignoresSafeArea()
			
			VStack(spacing: 30) {
				// Shimmer Text
				Text("An Pham Ngoc...")
					.font(.system(size: 32, weight: .bold))
					.foregroundColor(.white)
					.shimmering()
				
				Text("An Pham Ngoc...")
									.font(.system(size: 32, weight: .bold))
									.foregroundStyle(
										LinearGradient(
											gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple]),
											startPoint: .leading,
											endPoint: .trailing
										)
									)
									.shimmering()
				
				Text("Welcome Swift")
								.font(.system(size: 36, weight: .bold))
								// Gradient dùng .mask
								.foregroundColor(.white)
								.overlay(
									LinearGradient(
										gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple]),
										startPoint: animate ? .leading : .trailing,
										endPoint: animate ? .trailing : .leading
									)
									.mask(Text("Welcome Swift")
											.font(.system(size: 36, weight: .bold))
									)
									.animation(.linear(duration: 2).repeatForever(autoreverses: true), value: animate)
								)
								.shimmering()
								.onAppear {
									animate = true
								}
				
				// Shimmer Rectangle
				RoundedRectangle(cornerRadius: 12)
					.fill(Color.gray.opacity(0.3))
					.frame(width: 280, height: 60)
					.overlay(
						Text("Loading...")
							.foregroundColor(.white)
							.font(.system(size: 20, weight: .medium))
							.shimmering()
					)
				
				// Shimmer Circle
				Circle()
					.fill(Color.gray.opacity(0.3))
					.frame(width: 100, height: 100)
					.shimmering()
			}
		}
	}
}
