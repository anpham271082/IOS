//
//  RadialMenu.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 8/25/25.
//

import SwiftUI

struct RadialMenu: View {
	// --- Customizable values ---
	var menuRadius: CGFloat = 60       // bán kính vòng menu
	var centerCircleSize: CGFloat = 40 // size nút trung tâm
	var menuSize: CGFloat = 210        // size tổng view menu
	var menuItems: [String] = ["person", "gearshape", "magnifyingglass", "heart", "bell", "message"]
	
	let segmentColor = Color(hex: "181818")
	let strokeColor = Color(hex: "282828")
	let selectedTintColor = Color(hex: "383838")
	
	// --- State ---
	@State private var isMenuOpen = false
	@State private var dragOffset: CGSize = .zero
	@State private var selectedSegment: Int? = nil
	@State private var dragDistance: CGFloat = 0
	@State private var menuScale: CGFloat = 0.01
	@State private var menuOpacity: Double = 0

	// --- Helpers ---
	func calculateSelectedSegment(from offset: CGSize) -> Int? {
		guard dragDistance > 5 else { return nil }
		let angle = atan2(offset.height, offset.width) * 180 / .pi
		let normalizedAngle = (angle + 360).truncatingRemainder(dividingBy: 360)
		let segmentSize = 360.0 / Double(menuItems.count)
		let segment = Int(((normalizedAngle + segmentSize / 2).truncatingRemainder(dividingBy: 360)) / segmentSize)
		return segment
	}
	
	func calculateExpansion(for index: Int) -> CGFloat {
		guard let selected = selectedSegment, selected == index else { return 0 }
		return 0.3 * (1 - exp(-dragDistance / 50))
	}
	
	func getSegmentColor(for index: Int, expansion: CGFloat) -> Color {
		guard let selected = selectedSegment, selected == index else { return segmentColor }
		return segmentColor.interpolateTo(color: selectedTintColor, amount: expansion * 3)
	}
	
	func iconOffset(for index: Int) -> CGPoint {
		let segmentSize = 360.0 / Double(menuItems.count)
		let midAngle = Double(index) * segmentSize + segmentSize / 2
		let x = cos((midAngle - 90) * .pi / 180) * menuRadius
		let y = sin((midAngle - 90) * .pi / 180) * menuRadius
		return CGPoint(x: x, y: y)
	}

	// --- Body ---
	var body: some View {
		GeometryReader { geometry in
			VStack(alignment: .leading) {
				Text("Prototyping is an effective way in the design and development process to share ideas. It transforms abstract concepts into interactive designs, making them easier to evaluate and refine. By catching potential design or functional issues in the early stages, prototyping significantly reduces the risk of building ineffective solutions. It also plays an important role in fostering collaboration and communication among teams, as it provides a clear visual reference that everyone can understand.")
					.padding(.horizontal, 40)
					.padding(.top, -20)
					.foregroundColor(.black)
					.multilineTextAlignment(.leading)
					.lineSpacing(8)
					.font(.system(size: 16))
					.frame(maxWidth: 600, alignment: .leading)
			}
			.offset(y: 200)
			ZStack {
				// --- Menu Items ---
				ForEach(Array(menuItems.enumerated()), id: \.offset) { index, icon in
					let angle = Double(index) * (360.0 / Double(menuItems.count))
					let nextAngle = Double(index + 1) * (360.0 / Double(menuItems.count))
					let expansion = calculateExpansion(for: index)
					let iconPosition = iconOffset(for: index)
					
					PieSegment(startAngle: .degrees(angle), endAngle: .degrees(nextAngle), expansion: expansion)
						.fill(getSegmentColor(for: index, expansion: expansion))
						.overlay(
							PieSegment(startAngle: .degrees(angle), endAngle: .degrees(nextAngle), expansion: expansion)
								.stroke(strokeColor, lineWidth: 1.5)
						)
						.overlay(
							Image(systemName: icon)
								.font(.system(size: 22))
								.foregroundColor(selectedSegment == index ? .white : .white.opacity(0.3))
								.offset(x: iconPosition.x * (1 + expansion * 0.3),
										y: iconPosition.y * (1 + expansion * 0.3))
								.scaleEffect(1 + expansion * 0.3)
						)
						.animation(
							selectedSegment != nil ?
								.interpolatingSpring(stiffness: 300, damping: 15)
								: .easeOut(duration: 0.2),
							value: expansion
						)
				}
				.frame(width: menuSize, height: menuSize)
				.scaleEffect(menuScale)
				.opacity(menuOpacity)
				
				// --- Center Button ---
				Circle()
					.fill(segmentColor)
					.frame(width: centerCircleSize, height: centerCircleSize)
					.overlay(
						Image(systemName: "plus")
							.font(.system(size: centerCircleSize * 0.5))
							.foregroundColor(.white)
							.rotationEffect(.degrees(isMenuOpen ? 45 : 0))
					)
					.gesture(
						DragGesture(minimumDistance: 0)
							.onChanged { value in
								dragOffset = value.translation
								dragDistance = sqrt(pow(value.translation.width, 2) + pow(value.translation.height, 2))
								
								if !isMenuOpen {
									withAnimation(.easeOut(duration: 0.2)) {
										isMenuOpen = true
										menuScale = 1
										menuOpacity = 1
									}
								}
								
								let isDraggingTowardCenter = dragDistance < 40
								
								if isDraggingTowardCenter {
									withAnimation(.easeOut(duration: 0.2)) {
										menuScale = 0.8
										menuOpacity = 0.5
										selectedSegment = nil
									}
								} else {
									withAnimation(.interpolatingSpring(stiffness: 400, damping: 20)) {
										menuScale = 1
										menuOpacity = 1
										selectedSegment = calculateSelectedSegment(from: value.translation)
									}
								}
							}
							.onEnded { _ in
								if let selected = selectedSegment {
									let generator = UIImpactFeedbackGenerator(style: .medium)
									generator.impactOccurred()
									print("Selected: \(menuItems[selected])")
								}
								
								withAnimation(.interpolatingSpring(stiffness: 300, damping: 15)) {
									isMenuOpen = false
									menuScale = 0.01
									menuOpacity = 0
									dragOffset = .zero
									dragDistance = 0
									selectedSegment = nil
								}
							}
					)
			}
			.frame(width: geometry.size.width, height: geometry.size.height)
			.position(x: geometry.size.width / 2, y: geometry.size.height - menuRadius - 150)
		}
		.ignoresSafeArea()
	}
}

// --- PieSegment Shape ---
struct PieSegment: Shape {
	var startAngle: Angle
	var endAngle: Angle
	var expansion: CGFloat
	
	var animatableData: CGFloat {
		get { expansion }
		set { expansion = newValue }
	}
	
	func path(in rect: CGRect) -> Path {
		var path = Path()
		let center = CGPoint(x: rect.midX, y: rect.midY)
		let radius = min(rect.width, rect.height) / 2
		let expandedRadius = radius * (1 + expansion)
		let innerRadius: CGFloat = 40
		
		path.move(to: center)
		path.addArc(center: center, radius: expandedRadius, startAngle: startAngle - .degrees(90), endAngle: endAngle - .degrees(90), clockwise: false)
		path.addArc(center: center, radius: innerRadius, startAngle: endAngle - .degrees(90), endAngle: startAngle - .degrees(90), clockwise: true)
		path.closeSubpath()
		return path
	}
}

// --- Color Extensions ---
extension Color {
	init(hex: String) {
		let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int: UInt64 = 0
		Scanner(string: hex).scanHexInt64(&int)
		let a, r, g, b: UInt64
		switch hex.count {
		case 3:
			(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
		case 6:
			(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
		case 8:
			(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
		default:
			(a, r, g, b) = (255, 0, 0, 0)
		}
		self.init(.sRGB,
				  red: Double(r) / 255,
				  green: Double(g) / 255,
				  blue:  Double(b) / 255,
				  opacity: Double(a) / 255)
	}
	
	func interpolateTo(color: Color, amount: CGFloat) -> Color {
		let amount = min(max(amount, 0), 1)
		guard let fromComponents = UIColor(self).getRGBA(), let toComponents = UIColor(color).getRGBA() else { return self }
		let red = fromComponents.red + (toComponents.red - fromComponents.red) * amount
		let green = fromComponents.green + (toComponents.green - fromComponents.green) * amount
		let blue = fromComponents.blue + (toComponents.blue - fromComponents.blue) * amount
		let alpha = fromComponents.alpha + (toComponents.alpha - fromComponents.alpha) * amount
		return Color(UIColor(red: red, green: green, blue: blue, alpha: alpha))
	}
}

extension UIColor {
	func getRGBA() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
		var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
		guard self.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
		return (r, g, b, a)
	}
}
