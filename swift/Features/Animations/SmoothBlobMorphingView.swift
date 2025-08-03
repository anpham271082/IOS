//
//  MorphingShapeView.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/31/25.
//

import SwiftUI

struct MultiShapeMorphingView: View {
	@State private var stage: Int = 0
	@State private var isAnimating: Bool = true
	
	// Timer chạy mỗi 2 giây, tự động update stage nếu đang chạy
	let timer = Timer.publish(every: 2.0, on: .main, in: .common).autoconnect()
	
	var body: some View {
		VStack(spacing: 40) {
			MorphingShape(progress: CGFloat(stage) / 2)
				.stroke(
					LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
								   startPoint: .topLeading,
								   endPoint: .bottomTrailing),
					lineWidth: 6
				)
				.background(
					MorphingShape(progress: CGFloat(stage) / 2)
						.fill(
							LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
										   startPoint: .topLeading,
										   endPoint: .bottomTrailing)
						)
				)
				.frame(width: 250, height: 250)
				.animation(.easeInOut(duration: 1.2), value: stage)
				.onTapGesture {
					isAnimating.toggle()
				}
				.overlay(
					Text(isAnimating ? "Tap to Pause" : "Tap to Resume")
						.foregroundColor(.gray)
						.font(.footnote)
						.padding(.top, 280)
				)
			
			Text(isAnimating ? "Animation Running" : "Animation Paused")
				.font(.title3)
				.foregroundColor(isAnimating ? .green : .red)
				.animation(nil, value: isAnimating)
		}
		.onReceive(timer) { _ in
			guard isAnimating else { return }
			withAnimation(.easeInOut(duration: 1.2)) {
				stage = (stage + 1) % 3
			}
		}
		.padding()
		.navigationTitle("Smooth Morphing")
		.navigationBarTitleDisplayMode(.inline)
	}
}

struct MorphingShape: Shape {
	var progress: CGFloat // 0 = circle, 0.5 = pentagon, 1 = trapezoid
	
	var animatableData: CGFloat {
		get { progress }
		set { progress = newValue }
	}
	
	func path(in rect: CGRect) -> Path {
		let center = CGPoint(x: rect.midX, y: rect.midY)
		let radius = min(rect.width, rect.height) / 2 * 0.9
		
		var path = Path()
		
		let t = progress
		
		if t <= 0 {
			path.addEllipse(in: CGRect(x: center.x - radius, y: center.y - radius,
									   width: radius * 2, height: radius * 2))
			return path
		}
		
		// Pentagon 5 points
		let pentagonPoints = (0..<5).map { i -> CGPoint in
			let angle = CGFloat(i) * (2 * .pi / 5) - .pi / 2
			return CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
		}
		
		// Trapezoid points (4 points + repeat first point)
		let topBaseHalf: CGFloat = radius * 0.6
		let bottomBaseHalf: CGFloat = radius
		
		let trapezoidPoints = [
			CGPoint(x: center.x - topBaseHalf, y: center.y - radius * 0.8),
			CGPoint(x: center.x + topBaseHalf, y: center.y - radius * 0.8),
			CGPoint(x: center.x + bottomBaseHalf, y: center.y + radius * 0.8),
			CGPoint(x: center.x - bottomBaseHalf, y: center.y + radius * 0.8),
			CGPoint(x: center.x - topBaseHalf, y: center.y - radius * 0.8)
		]
		
		func lerp(_ a: CGPoint, _ b: CGPoint, t: CGFloat) -> CGPoint {
			CGPoint(x: a.x + (b.x - a.x) * t,
					y: a.y + (b.y - a.y) * t)
		}
		
		func samplePolygonEdges(points: [CGPoint], count: Int) -> [CGPoint] {
			var sampled: [CGPoint] = []
			let edges = points.count
			let pointsPerEdge = count / edges
			
			for i in 0..<edges {
				let start = points[i]
				let end = points[(i + 1) % edges]
				for j in 0..<pointsPerEdge {
					let t = CGFloat(j) / CGFloat(pointsPerEdge)
					sampled.append(lerp(start, end, t: t))
				}
			}
			return sampled
		}
		
		func interpolatePoints(t: CGFloat) -> [CGPoint] {
			if t <= 0.5 {
				// Morph circle -> pentagon
				let circlePoints = (0..<100).map { i -> CGPoint in
					let angle = 2 * .pi * CGFloat(i) / 100 - .pi/2
					return CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
				}
				let pentPoints = samplePolygonEdges(points: pentagonPoints, count: 100)
				return zip(circlePoints, pentPoints).map { lerp($0, $1, t: t * 2) }
			} else {
				// Morph pentagon -> trapezoid
				return zip(pentagonPoints, trapezoidPoints).map { lerp($0, $1, t: (t - 0.5) * 2) }
			}
		}
		
		let points: [CGPoint]
		if t <= 0.5 {
			points = interpolatePoints(t: t)
			path.move(to: points[0])
			for i in 1..<points.count {
				path.addLine(to: points[i])
			}
			path.closeSubpath()
		} else {
			points = interpolatePoints(t: t)
			path.move(to: points[0])
			for pt in points.dropFirst() {
				path.addLine(to: pt)
			}
			path.closeSubpath()
		}
		
		return path
	}
}
