//
//  PageCurlContentView.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 8/1/25.
//

import SwiftUI

struct PageCurlContentView: View {
	@State private var currentIndex: Int = 0

	var body: some View {
		PageCurlControllerWithState(
			currentIndex: $currentIndex,
			pages: [
				PageHostingController(rootView: PageView(
					text: "📘 Page 1", color: .gray,
					index: 0, maxIndex: 3, currentIndex: $currentIndex)),
				PageHostingController(rootView: PageView(
					text: "📙 Page 2", color: .gray,
					index: 1, maxIndex: 3, currentIndex: $currentIndex)),
				PageHostingController(rootView: PageView(
					text: "📗 Page 3", color: .gray,
					index: 2, maxIndex: 3, currentIndex: $currentIndex)),
				PageHostingController(rootView: PageView(
					text: "📕 Page 4", color: .gray,
					index: 3, maxIndex: 3, currentIndex: $currentIndex))
			]
		)
		.edgesIgnoringSafeArea(.all)
	}
}
struct PageCurlControllerWithState: UIViewControllerRepresentable {
	@Binding var currentIndex: Int
	let pages: [UIViewController]

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	func makeUIViewController(context: Context) -> UIPageViewController {
		let controller = UIPageViewController(
			transitionStyle: .pageCurl,
			navigationOrientation: .horizontal,
			options: nil
		)
		controller.dataSource = context.coordinator
		controller.setViewControllers([pages[currentIndex]], direction: .forward, animated: true)
		return controller
	}

	func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
		let currentVC = uiViewController.viewControllers?.first
		let currentVCIndex = pages.firstIndex(of: currentVC ?? UIViewController()) ?? 0
		
		// 🛑 Chỉ set lại khi index thật sự thay đổi
		if currentVCIndex != currentIndex {
			let direction: UIPageViewController.NavigationDirection = currentIndex > currentVCIndex ? .forward : .reverse
			uiViewController.setViewControllers([pages[currentIndex]], direction: direction, animated: true)
		}
	}

	class Coordinator: NSObject, UIPageViewControllerDataSource {
		var parent: PageCurlControllerWithState

		init(_ parent: PageCurlControllerWithState) {
			self.parent = parent
		}

		func pageViewController(_ pageViewController: UIPageViewController,
								viewControllerBefore viewController: UIViewController) -> UIViewController? {
			guard let index = parent.pages.firstIndex(of: viewController), index > 0 else { return nil }
			DispatchQueue.main.async {
				self.parent.currentIndex = index - 1
			}
			return parent.pages[index - 1]
		}

		func pageViewController(_ pageViewController: UIPageViewController,
								viewControllerAfter viewController: UIViewController) -> UIViewController? {
			guard let index = parent.pages.firstIndex(of: viewController),
				  index < parent.pages.count - 1 else { return nil }
			DispatchQueue.main.async {
				self.parent.currentIndex = index + 1
			}
			return parent.pages[index + 1]
		}
	}
}

struct Article: Identifiable {
	let id = UUID()
	let title: String
	let subtitle: String
	let icon: String
	let imageName: String
}

struct PageView: View {
	let text: String
	let color: Color
	let index: Int
	let maxIndex: Int
	@Binding var currentIndex: Int

	// Random article generator
	let articles: [Article] = (1...10).map { i in
		Article(
			title: ["SwiftUI Animations", "UI Design Patterns", "Top 10 iOS Tricks", "Performance Boost", "Architecture Clean Code"].randomElement()!,
			subtitle: ["Learn step-by-step", "Updated for 2025", "With full code", "Best for pro devs"].randomElement()!,
			icon: ["bookmark.fill", "bolt.fill", "heart.fill", "star.fill"].randomElement()!,
			imageName: ["Frankfurt", "Hamburg", "PalmSprings", "RedRockCanyon", "Strasbourg"].randomElement()!
		)
	}
	var body: some View {
		ZStack {
			color.ignoresSafeArea()
			VStack(spacing: 16) {
				Text(text)
					.font(.largeTitle.bold())
					.foregroundColor(.white)
					.padding(.top, 40)

				HStack(spacing: 16) {
					// Previous Button
					Button(action: {
						if currentIndex > 0 {
							currentIndex -= 1
						}
					}) {
						HStack(spacing: 6) {
							Image(systemName: "chevron.left.circle.fill")
								.font(.title2)
							Text("Previous")
								.font(.subheadline)
								.fontWeight(.medium)
						}
						.foregroundColor(.white)
						.padding(.vertical, 10)
						.padding(.horizontal, 16)
						.background(
							LinearGradient(gradient: Gradient(colors: [Color.gray, Color.black]),
										   startPoint: .topLeading,
										   endPoint: .bottomTrailing)
						)
						.cornerRadius(12)
						.shadow(radius: 4)
					}

					Spacer()

					// Next Button
					Button(action: {
						if currentIndex < maxIndex {
							currentIndex += 1
						}
					}) {
						HStack(spacing: 6) {
							Text("Next")
								.font(.subheadline)
								.fontWeight(.medium)
							Image(systemName: "chevron.right.circle.fill")
								.font(.title2)
						}
						.foregroundColor(.white)
						.padding(.vertical, 10)
						.padding(.horizontal, 16)
						.background(
							LinearGradient(gradient: Gradient(colors: [Color.gray, Color.black]),
										   startPoint: .topLeading,
										   endPoint: .bottomTrailing)
						)
						.cornerRadius(12)
						.shadow(radius: 4)
					}
				}
				.padding(.horizontal)
				.padding(.top, 12)

				ScrollView {
					LazyVStack(spacing: 20) {
						ForEach(articles) { article in
							ZStack(alignment: .bottomLeading) {
								Image(article.imageName)
									.resizable()
									.scaledToFill()
									.frame(height: 200)
									.clipped()
									.cornerRadius(16)

								LinearGradient(
									gradient: Gradient(colors: [.black.opacity(0.8), .clear]),
									startPoint: .bottom,
									endPoint: .top
								)
								.cornerRadius(16)

								HStack {
									Image(systemName: article.icon)
										.foregroundColor(.yellow)
										.padding(.trailing, 6)

									VStack(alignment: .leading, spacing: 4) {
										Text(article.title)
											.font(.headline)
											.foregroundColor(.white)

										Text(article.subtitle)
											.font(.caption)
											.foregroundColor(.white.opacity(0.7))
									}
								}
								.padding()
							}
							.padding(.horizontal)
							.shadow(radius: 6)
						}
					}
					.padding(.bottom, 60)
				}
			}
		}
	}
}
