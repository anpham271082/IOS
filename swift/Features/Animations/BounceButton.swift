//
//  BounceButton.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/31/25.
//

import SwiftUI
enum ButtonStyleTheme {
	case luxury, neon, shopping

	var background: LinearGradient {
		switch self {
		case .luxury:
			return LinearGradient(colors: [Color(white: 0.2), Color(white: 0.05)],
								  startPoint: .topLeading,
								  endPoint: .bottomTrailing)
		case .neon:
			return LinearGradient(colors: [Color.pink, Color.purple, Color.blue],
								  startPoint: .topLeading,
								  endPoint: .bottomTrailing)
		case .shopping:
			return LinearGradient(colors: [Color.orange, Color.red],
								  startPoint: .leading,
								  endPoint: .trailing)
		}
	}

	var shadow: Color {
		switch self {
		case .luxury:
			return Color.black.opacity(0.4)
		case .neon:
			return Color.purple.opacity(0.5)
		case .shopping:
			return Color.red.opacity(0.3)
		}
	}
}

struct PremiumBounceButton<Label: View>: View {
	var action: () -> Void
	var label: () -> Label
	var theme: ButtonStyleTheme

	@GestureState private var isPressed = false
	@State private var animateGlow = false

	var body: some View {
		label()
			.font(.headline)
			.foregroundColor(.white)
			.padding(.horizontal, 28)
			.padding(.vertical, 16)
			.background(
				ZStack {
					theme.background
						.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

					RoundedRectangle(cornerRadius: 20)
						.stroke(theme.background, lineWidth: animateGlow ? 2 : 1)
						.blur(radius: animateGlow ? 1.5 : 5)
						.opacity(animateGlow ? 0.9 : 0)
						.animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateGlow)
				}
			)
			.clipShape(RoundedRectangle(cornerRadius: 20))
			.scaleEffect(isPressed ? 0.94 : 1.0)
			.shadow(color: theme.shadow, radius: isPressed ? 6 : 14, x: 0, y: isPressed ? 2 : 6)
			.gesture(
				DragGesture(minimumDistance: 0)
					.updating($isPressed) { _, state, _ in
						state = true
					}
					.onEnded { _ in
						UIImpactFeedbackGenerator(style: .light).impactOccurred()
						action()
					}
			)
			.onAppear {
				animateGlow = true
			}
	}
}
