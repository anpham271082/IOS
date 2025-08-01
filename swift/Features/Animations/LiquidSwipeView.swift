//
//  LiquidSwipeView.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/31/25.
//

import SwiftUI
struct LiquidSwipeView: View {
	@State private var dragX: CGFloat = 0
	@State private var isSwiped = false
	@State private var wavePhase: CGFloat = 0
	
	let maxDrag: CGFloat = 300
	let wavePoints = 9
	
	var body: some View {
		ZStack {
			LinearGradient(
				gradient: Gradient(colors: isSwiped ? [.purple, .black] : [.blue, .cyan]),
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
			.ignoresSafeArea()
			.animation(.easeInOut(duration: 0.7), value: isSwiped)
			
			VStack {
				Spacer()
				Text(isSwiped ? "Next Screen" : "Welcome")
					.font(.system(size: 48, weight: .bold, design: .rounded))
					.foregroundColor(.white)
					.shadow(radius: 8)
					.offset(x: isSwiped ? -150 : 0)
					.opacity(isSwiped ? 0 : 1)
					.animation(.easeInOut(duration: 0.5), value: isSwiped)
				Spacer()
			}
			
			TiltedLiquidShape(offsetX: dragX, wavePhase: wavePhase, pointsCount: wavePoints)
				.fill(
					LinearGradient(
						gradient: Gradient(colors: [.white.opacity(0.15), .white.opacity(0.05)]),
						startPoint: .top,
						endPoint: .bottom
					)
				)
				.blendMode(.screen)
				.ignoresSafeArea()
				.animation(.interactiveSpring(response: 0.5, dampingFraction: 0.8), value: dragX)
			
			VStack {
				Spacer()
				HStack {
					Spacer()
					Circle()
						.fill(
							RadialGradient(
								gradient: Gradient(colors: [.white, .blue]),
								center: .center,
								startRadius: 10,
								endRadius: 50
							)
						)
						.frame(width: 80, height: 80)
						.shadow(color: .white.opacity(0.6), radius: 15, x: 0, y: 5)
						.offset(x: dragX)
						.gesture(
							DragGesture()
								.onChanged { value in
									if value.translation.width < 0 {
										dragX = max(value.translation.width, -maxDrag)
									}
								}
								.onEnded { _ in
									if dragX < -maxDrag / 2 {
										withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
											dragX = -maxDrag
											isSwiped = true
										}
									} else {
										withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
											dragX = 0
											isSwiped = false
										}
									}
								}
						)
						.animation(.easeInOut(duration: 0.4), value: dragX)
						.padding(.trailing, 20)
				}
			}
		}
		.onAppear {
			withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
				wavePhase = 360
			}
		}
	}
}

struct TiltedLiquidShape: Shape {
	var offsetX: CGFloat
	var wavePhase: CGFloat
	let pointsCount: Int
	
	var animatableData: AnimatablePair<CGFloat, CGFloat> {
		get { AnimatablePair(offsetX, wavePhase) }
		set {
			offsetX = newValue.first
			wavePhase = newValue.second
		}
	}
	
	func path(in rect: CGRect) -> Path {
		let width = rect.width
		let height = rect.height
		
		// Base line nghiêng từ góc trên phải xuống gần đáy bên trái
		let baseStart = CGPoint(x: width, y: 0)
		let baseEnd = CGPoint(x: width * 0.4 + offsetX * 0.8, y: height)
		
		// Tạo các điểm sóng trên đường chéo baseStart->baseEnd
		var points: [CGPoint] = []
		for i in 0..<pointsCount {
			let t = CGFloat(i) / CGFloat(pointsCount - 1)
			let x = baseStart.x + (baseEnd.x - baseStart.x) * t
			let y = baseStart.y + (baseEnd.y - baseStart.y) * t
			let wave = sin((wavePhase * .pi / 180) + t * .pi * 4) * 30
			points.append(CGPoint(x: x + wave, y: y))
		}
		
		var path = Path()
		// Bắt đầu góc trên trái
		path.move(to: CGPoint(x: 0, y: 0))
		// Đường thẳng đến điểm baseStart
		path.addLine(to: baseStart)
		
		// Vẽ đường cong Bézier mượt qua các điểm sóng
		path.addPath(smoothCurve(points: points))
		
		// Đường thẳng xuống góc dưới trái
		path.addLine(to: CGPoint(x: 0, y: height))
		path.closeSubpath()
		
		return path
	}
	
	// Hàm tạo path smooth Bézier qua nhiều điểm với control points tự tính
	func smoothCurve(points: [CGPoint]) -> Path {
		var path = Path()
		guard points.count > 1 else { return path }
		
		path.move(to: points[0])
		
		for i in 0..<points.count-1 {
			let p0 = points[i]
			let p1 = points[i + 1]
			
			// Tính control points cho smooth curve:
			// Tạo control points dựa trên vector giữa điểm trước và sau
			// Để đơn giản, ta tính trung điểm 2 điểm lân cận, rồi offset control points
			
			let prev = i == 0 ? p0 : points[i - 1]
			let next = i + 2 < points.count ? points[i + 2] : p1
			
			let control1 = CGPoint(
				x: p0.x + (p1.x - prev.x) / 6,
				y: p0.y + (p1.y - prev.y) / 6
			)
			
			let control2 = CGPoint(
				x: p1.x - (next.x - p0.x) / 6,
				y: p1.y - (next.y - p0.y) / 6
			)
			
			path.addCurve(to: p1, control1: control1, control2: control2)
		}
		
		return path
	}
}
