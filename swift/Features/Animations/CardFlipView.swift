//
//  CardFlipView.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/31/25.
//
import SwiftUI

struct CardFlipView: View {
	@State private var flipped = false

	var body: some View {
		VStack {
			Spacer()

			FlipCard(
				isFlipped: $flipped,
				front: {
					CardFaceView(text: "Front", color: .blue)
				},
				back: {
					CardFaceView(text: "Back", color: .orange)
				}
			)
			.frame(width: 250, height: 350)
			.onTapGesture {
				withAnimation(.easeInOut(duration: 0.8)) {
					flipped.toggle()
				}
			}

			Spacer()
			Text("Tap card to flip")
				.font(.title2)
		}
	}
}

struct FlipCard<Front: View, Back: View>: View {
	@Binding var isFlipped: Bool
	var front: () -> Front
	var back: () -> Back

	init(isFlipped: Binding<Bool>, @ViewBuilder front: @escaping () -> Front, @ViewBuilder back: @escaping () -> Back) {
		self._isFlipped = isFlipped
		self.front = front
		self.back = back
	}

	var body: some View {
		ZStack {
			front()
				.opacity(isFlipped ? 0.0 : 1.0)
				.rotation3DEffect(.degrees(isFlipped ? 180 : 0),
								  axis: (x: 0, y: 1, z: 0),
								  perspective: 0.6)

			back()
				.opacity(isFlipped ? 1.0 : 0.0)
				.rotation3DEffect(.degrees(isFlipped ? 0 : -180),
								  axis: (x: 0, y: 1, z: 0),
								  perspective: 0.6)
		}
		.animation(.easeInOut(duration: 0.8), value: isFlipped)
		.shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
	}
}

struct CardFaceView: View {
	let text: String
	let color: Color

	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 20)
				.fill(LinearGradient(
					gradient: Gradient(colors: [color.opacity(0.9), color]),
					startPoint: .topLeading,
					endPoint: .bottomTrailing))
				.shadow(radius: 8)

			Text(text)
				.font(.system(size: 36, weight: .bold))
				.foregroundColor(.white)
		}
	}
}
