//
//  FullScreenZoomImageViewController.swift
//  my_app_ios
//
//  Created by An Pham Ngoc on 8/12/25.
//

import UIKit
import SDWebImage

class FullScreenZoomImageViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
	private let imageUrl: String
	private let scrollView = UIScrollView()
	private let rotationContainer = UIView() // View chứa ảnh để xoay
	private let imageView = UIImageView()
	
	init(imageUrl: String) {
		self.imageUrl = imageUrl
		super.init(nibName: nil, bundle: nil)
		modalPresentationCapturesStatusBarAppearance = true
	}
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	override var prefersStatusBarHidden: Bool { true }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .black
		setupScrollView()
		setupImage()
		setupGestures()
		setupBackButton()
	}
	
	// MARK: ScrollView
	private func setupScrollView() {
		scrollView.frame = view.bounds
		scrollView.delegate = self
		scrollView.minimumZoomScale = 1.0
		scrollView.maximumZoomScale = 3.0
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.showsVerticalScrollIndicator = false
		scrollView.bouncesZoom = true
		view.addSubview(scrollView)
	}
	
	// MARK: Image
	private func setupImage() {
		rotationContainer.frame = scrollView.bounds
		rotationContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
		imageView.frame = rotationContainer.bounds
		imageView.contentMode = .scaleAspectFit
		imageView.isUserInteractionEnabled = true
		imageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5) // Giữ xoay quanh tâm
		
		if let url = URL(string: imageUrl) {
			imageView.sd_setImage(with: url, placeholderImage: nil, options: [.continueInBackground, .progressiveLoad])
		}
		
		rotationContainer.addSubview(imageView)
		scrollView.addSubview(rotationContainer)
		centerImage()
	}
	
	// MARK: Gestures
	private func setupGestures() {
		// Double tap zoom
		let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
		doubleTap.numberOfTapsRequired = 2
		scrollView.addGestureRecognizer(doubleTap)
		
		// Rotation
		let rotation = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
		rotation.delegate = self
		rotationContainer.addGestureRecognizer(rotation)
	}
	
	@objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
		if scrollView.zoomScale == 1 {
			let point = gesture.location(in: imageView)
			let zoomRect = zoomRectForScale(scale: scrollView.maximumZoomScale, center: point)
			scrollView.zoom(to: zoomRect, animated: true)
		} else {
			scrollView.setZoomScale(1, animated: true)
		}
	}
	
	private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
		var zoomRect = CGRect.zero
		let size = scrollView.bounds.size
		zoomRect.size.width = size.width / scale
		zoomRect.size.height = size.height / scale
		zoomRect.origin.x = center.x - zoomRect.width / 2.0
		zoomRect.origin.y = center.y - zoomRect.height / 2.0
		return zoomRect
	}
	
	@objc private func handleRotation(_ gesture: UIRotationGestureRecognizer) {
		switch gesture.state {
		case .began, .changed:
			imageView.transform = imageView.transform.rotated(by: gesture.rotation)
			gesture.rotation = 0
		case .ended, .cancelled:
			centerImage() // Cập nhật lại vị trí khi xoay xong
		default:
			break
		}
	}
	
	// MARK: Back Button
	private func setupBackButton() {
		let backButton = UIButton(type: .system)
		backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
		backButton.tintColor = .white
		backButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		backButton.layer.cornerRadius = 20
		backButton.clipsToBounds = true
		backButton.addTarget(self, action: #selector(close), for: .touchUpInside)
		
		view.addSubview(backButton)
		backButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
			backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			backButton.widthAnchor.constraint(equalToConstant: 40),
			backButton.heightAnchor.constraint(equalToConstant: 40)
		])
	}
	
	@objc private func close() {
		dismiss(animated: true)
	}
	
	// MARK: UIScrollViewDelegate
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return rotationContainer
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		centerImage()
	}
	
	private func centerImage() {
		let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
		let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
		rotationContainer.center = CGPoint(
			x: scrollView.contentSize.width * 0.5 + offsetX,
			y: scrollView.contentSize.height * 0.5 + offsetY
		)
	}
	
	// MARK: UIGestureRecognizerDelegate
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}

