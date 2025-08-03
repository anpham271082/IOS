//
//  SmoothScrollView.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 7/31/25.
//

import SwiftUI

struct SmoothScrollView: View {
var body: some View {
	   NavigationView {
		   ScrollView {
			   VStack(spacing: 30) {
				   ForEach(0..<imageUrls.count, id: \.self) { i in
					   ParallaxCardView(index: i)
						   .frame(height: 280)
						   .padding(.horizontal)
						   .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
				   }
			   }
			   .padding(.vertical, 40)
		   }
		   .background(LinearGradient(colors: [.white, .blue.opacity(0.05)], startPoint: .top, endPoint: .bottom))
		   .scrollIndicators(.hidden)
	   }
	   .navigationTitle("🌍 Smooth Scroll + Parallax")
	   .navigationBarTitleDisplayMode(.inline)
   }
	
}

// MARK: - Card View
struct ParallaxCardView: View {
   let index: Int
   @State private var isTapped = false

   var imageURL: URL {
	   let base = imageUrls[index % imageUrls.count]
	   return URL(string: base + "?w=800&h=600&fit=crop")!
   }

   var body: some View {
	   GeometryReader { geo in
		   let minY = geo.frame(in: .global).minY
		   let offset = minY / 20

		   ZStack(alignment: .bottomLeading) {
			   AsyncImage(url: imageURL) { phase in
				   switch phase {
				   case .empty:
					   ZStack {
						   Color.gray.opacity(0.15)
						   ProgressView()
					   }
				   case .success(let image):
					   image
						   .resizable()
						   .scaledToFill()
						   .frame(width: geo.size.width, height: geo.size.height + 100)
						   .offset(y: -offset)
						   .clipped()
						   .blur(radius: isTapped ? 0 : 0.2)
				   case .failure:
					   Color.red.opacity(0.3)
						   .overlay(Image(systemName: "exclamationmark.triangle.fill")
							   .font(.largeTitle)
							   .foregroundColor(.white))
				   @unknown default:
					   EmptyView()
				   }
			   }
			   .animation(.easeInOut(duration: 0.4), value: isTapped)

			   LinearGradient(
				   gradient: Gradient(colors: [.clear, .black.opacity(0.55)]),
				   startPoint: .center, endPoint: .bottom
			   )

			   VStack(alignment: .leading, spacing: 12) {
				   Label {
					   Text("Destination \(index + 1)")
						   .font(.title3.bold())
						   .foregroundColor(.white)
				   } icon: {
					   Image(systemName: iconFor(index: index))
						   .font(.system(size: 28))
						   .foregroundColor(.white)
						   .shadow(color: .black, radius: 3)
						   .scaleEffect(isTapped ? 1.2 : 1.0)
						   .rotationEffect(.degrees(isTapped ? 10 : 0))
						   .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isTapped)
				   }

				   Text("Explore Nature & Beyond")
					   .font(.subheadline)
					   .foregroundColor(.white.opacity(0.85))
					   .shadow(radius: 1)
			   }
			   .padding()
		   }
		   .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
		   .onTapGesture {
			   isTapped.toggle()
		   }
		   .scaleEffect(minY < 200 ? 1.0 : 0.95)
		   .animation(.easeOut(duration: 0.3), value: minY)
	   }
   }
}

// MARK: - Icons
func iconFor(index: Int) -> String {
   let icons = [
	   "leaf.fill", "sun.max.fill", "flame.fill",
	   "moon.stars.fill", "globe.europe.africa.fill",
	   "snowflake", "mountain.2.fill", "wind", "tornado"
   ]
   return icons[index % icons.count]
}

// MARK: - Unsplash Image URLs
let imageUrls: [String] = [
   "https://images.unsplash.com/photo-1529333166437-7750a6dd5a70", // Beach
   "https://images.unsplash.com/photo-1507525428034-b723cf961d3e", // Ocean
   "https://images.unsplash.com/photo-1501785888041-af3ef285b470", // Desert
   "https://images.unsplash.com/photo-1519817650390-64a93db511aa", // Waterfall
   "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee", // Lake
   "https://images.unsplash.com/photo-1533063785124-61f139e032d3", // Jungle
   "https://images.unsplash.com/photo-1540206395-68808572332f",   // Sunset
   "https://images.unsplash.com/photo-1587502536263-9298c89eae87",  // Canyon
   "https://images.unsplash.com/photo-1506744038136-46273834b3fb"  // Mountain
]
