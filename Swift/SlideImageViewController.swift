//
//  SlideImageViewController.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 8/12/25.
//

import SwiftUI
import UIKit
import SDWebImage

// SwiftUI wrapper
struct SlideImageViewWrapper: UIViewControllerRepresentable {
	func makeUIViewController(context: Context) -> SlideImageViewController {
		return SlideImageViewController()
	}
	
	func updateUIViewController(_ uiViewController: SlideImageViewController, context: Context) {}
}

// Custom Carousel Layout
class CarouselFlowLayout: UICollectionViewFlowLayout {
	let scaleFactor: CGFloat = 0.2 // mức thu nhỏ tối đa
	let rotationFactor: CGFloat = 0.3 // độ nghiêng tối đa (radians)
	
	override func prepare() {
		super.prepare()
		// Giảm khoảng cách dòng để các ảnh gần nhau hơn
		minimumLineSpacing = 2
		// Tăng khoảng cách padding 2 bên
		sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		guard let attributes = super.layoutAttributesForElements(in: rect),
			  let collectionView = collectionView else { return nil }
		
		let centerX = collectionView.contentOffset.x + collectionView.bounds.width / 2
		
		for attr in attributes {
			let distance = attr.center.x - centerX
			let normalizedDistance = abs(distance) / (collectionView.bounds.width / 2)
			
			// Scale ảnh gần trung tâm lớn hơn
			let zoom = 1 - scaleFactor * min(1, normalizedDistance)
			attr.transform3D = CATransform3DScale(CATransform3DIdentity, zoom, zoom, 1)
			
			// Rotation Y nghiêng ảnh bên trái hoặc phải
			var transform = CATransform3DIdentity
			transform.m34 = -1 / 500 // tạo chiều sâu 3D
			let angle = rotationFactor * (distance / collectionView.bounds.width)
			transform = CATransform3DRotate(transform, angle, 0, 1, 0)
			attr.transform3D = CATransform3DConcat(attr.transform3D, transform)
			
			// Layer order ưu tiên ảnh gần trung tâm lên trên
			attr.zIndex = Int((1 - normalizedDistance) * 10)
			
			// Alpha mờ dần khi ra xa
			attr.alpha = 1 - min(1, normalizedDistance * 0.2)
		}
		
		return attributes
	}
	
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}
}

// Main ViewController
class SlideImageViewController: UIViewController {
	
	private let imageUrls: [String] = [
		"https://picsum.photos/id/1015/600/400",
		"https://picsum.photos/id/1016/600/400",
		"https://picsum.photos/id/1018/600/400",
		"https://picsum.photos/id/1020/600/400"
	]
	
	private var collectionView: UICollectionView!
	private var pageControl: UIPageControl!
	private var timer: Timer?
	private var currentIndex = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Slide Image Carousel"
		view.backgroundColor = .systemBackground
		setupCollectionView()
		setupPageControl()
		startAutoScroll()
	}
	
	private func setupCollectionView() {
		let layout = CarouselFlowLayout()
		layout.scrollDirection = .horizontal
		// Những thuộc tính spacing và inset đã thiết lập trong prepare() của layout
		
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.register(SlideImageCell.self, forCellWithReuseIdentifier: "SlideImageCell")
		collectionView.backgroundColor = .clear
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.isPagingEnabled = false
		collectionView.decelerationRate = .fast
		
		collectionView.dataSource = self
		collectionView.delegate = self
		
		view.addSubview(collectionView)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.heightAnchor.constraint(equalToConstant: 240)
		])
	}
	
	private func setupPageControl() {
		pageControl = UIPageControl()
		pageControl.numberOfPages = imageUrls.count
		pageControl.currentPage = 0
		pageControl.currentPageIndicatorTintColor = .systemBlue
		pageControl.pageIndicatorTintColor = .lightGray
		
		view.addSubview(pageControl)
		pageControl.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
			pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}
	
	private func startAutoScroll() {
		timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
			self.currentIndex = (self.currentIndex + 1) % self.imageUrls.count
			let indexPath = IndexPath(item: self.currentIndex, section: 0)
			self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
			self.pageControl.currentPage = self.currentIndex
		}
	}
	
	deinit {
		timer?.invalidate()
	}
}

extension SlideImageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return imageUrls.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideImageCell", for: indexPath) as? SlideImageCell else {
			return UICollectionViewCell()
		}
		cell.configure(with: imageUrls[indexPath.item])
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let fullVC = FullScreenZoomImageViewController(imageUrl: imageUrls[indexPath.item])
		fullVC.modalPresentationStyle = .fullScreen
		present(fullVC, animated: true)
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let centerPoint = CGPoint(x: collectionView.bounds.midX + collectionView.contentOffset.x,
								  y: collectionView.bounds.midY)
		if let indexPath = collectionView.indexPathForItem(at: centerPoint) {
			currentIndex = indexPath.item
			pageControl.currentPage = currentIndex
		}
	}
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = collectionView.bounds.width * 0.6
		return CGSize(width: width, height: collectionView.bounds.height * 0.9)
	}
}

// MARK: - Slide Cell
class SlideImageCell: UICollectionViewCell {
	private let imageView = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.layer.cornerRadius = 12
		contentView.clipsToBounds = true
		contentView.backgroundColor = .secondarySystemBackground
		
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		
		contentView.addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
	
	func configure(with urlString: String) {
		if let url = URL(string: urlString) {
			imageView.sd_setImage(
				with: url,
				placeholderImage: nil,
				options: [.continueInBackground, .progressiveLoad]
			)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
