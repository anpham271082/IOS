import UIKit
extension UIImage {
	func compressed(quality: CGFloat = 0.5) -> UIImage? {
		guard let data = jpegData(compressionQuality: quality) else { return nil }
		return UIImage(data: data)
	}
	func compressedData(quality: CGFloat = 0.5) -> Data? {
		return jpegData(compressionQuality: quality)
	}
	func cropped(to rect: CGRect) -> UIImage {
		guard rect.size.width <= size.width, rect.size.height <= size.height else { return self }
		let scaledRect = rect.applying(CGAffineTransform(scaleX: scale, y: scale))
		guard let image = cgImage?.cropping(to: scaledRect) else { return self }
		return UIImage(cgImage: image, scale: scale, orientation: imageOrientation)
	}
	func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
		let scale = toHeight / size.height
		let newWidth = size.width * scale
		let size = CGSize(width: newWidth, height: toHeight)
		let rect = CGRect(origin: .zero, size: size)

		#if os(watchOS)
		UIGraphicsBeginImageContextWithOptions(size, opaque, self.scale)
		defer { UIGraphicsEndImageContext() }
		draw(in: rect)
		return UIGraphicsGetImageFromCurrentImageContext()
		#else
		let format = UIGraphicsImageRendererFormat()
		format.scale = self.scale
		return UIGraphicsImageRenderer(size: size, format: format).image { _ in
			draw(in: rect)
		}
		#endif
	}
	func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
		let scale = toWidth / size.width
		let newHeight = size.height * scale
		let size = CGSize(width: toWidth, height: newHeight)
		let rect = CGRect(origin: .zero, size: size)

		#if os(watchOS)
		UIGraphicsBeginImageContextWithOptions(size, opaque, self.scale)
		defer { UIGraphicsEndImageContext() }
		draw(in: rect)
		return UIGraphicsGetImageFromCurrentImageContext()
		#else
		let format = UIGraphicsImageRendererFormat()
		format.scale = self.scale
		return UIGraphicsImageRenderer(size: size, format: format).image { _ in
			draw(in: rect)
		}
		#endif
	}
	///image.rotated(by: Measurement(value: 180, unit: .degrees))
	func rotated(by angle: Measurement<UnitAngle>) -> UIImage? {
		let radians = CGFloat(angle.converted(to: .radians).value)

		let destRect = CGRect(origin: .zero, size: size)
			.applying(CGAffineTransform(rotationAngle: radians))
		let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
									 y: destRect.origin.y.rounded(),
									 width: destRect.width.rounded(),
									 height: destRect.height.rounded())

		let actions = { (contextRef: CGContext) in
			contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
			contextRef.rotate(by: radians)

			self.draw(in: CGRect(origin: CGPoint(x: -self.size.width / 2,
												 y: -self.size.height / 2),
								 size: self.size))
		}

		#if os(watchOS)
		UIGraphicsBeginImageContextWithOptions(roundedDestRect.size, false, scale)
		defer { UIGraphicsEndImageContext() }
		guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }
		actions(contextRef)
		return UIGraphicsGetImageFromCurrentImageContext()
		#else
		let format = UIGraphicsImageRendererFormat()
		format.scale = scale
		return UIGraphicsImageRenderer(size: roundedDestRect.size, format: format).image {
			actions($0.cgContext)
		}
		#endif
	}
	///image.rotated(by: .pi)
	func rotated(by radians: CGFloat) -> UIImage? {
		let destRect = CGRect(origin: .zero, size: size)
			.applying(CGAffineTransform(rotationAngle: radians))
		let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
									 y: destRect.origin.y.rounded(),
									 width: destRect.width.rounded(),
									 height: destRect.height.rounded())

		let actions = { (contextRef: CGContext) in
			contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
			contextRef.rotate(by: radians)

			self.draw(in: CGRect(origin: CGPoint(x: -self.size.width / 2,
												 y: -self.size.height / 2),
								 size: self.size))
		}

		#if os(watchOS)
		UIGraphicsBeginImageContextWithOptions(roundedDestRect.size, false, scale)
		defer { UIGraphicsEndImageContext() }
		guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }
		actions(contextRef)
		return UIGraphicsGetImageFromCurrentImageContext()
		#else
		let format = UIGraphicsImageRendererFormat()
		format.scale = scale
		return UIGraphicsImageRenderer(size: roundedDestRect.size, format: format).image {
			actions($0.cgContext)
		}
		#endif
	}
	func filled(withColor color: UIColor) -> UIImage {
		#if os(watchOS)
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		defer { UIGraphicsEndImageContext() }
		color.setFill()
		guard let context = UIGraphicsGetCurrentContext() else { return self }

		context.translateBy(x: 0, y: size.height)
		context.scaleBy(x: 1.0, y: -1.0)
		context.setBlendMode(CGBlendMode.normal)

		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		guard let mask = cgImage else { return self }
		context.clip(to: rect, mask: mask)
		context.fill(rect)

		return UIGraphicsGetImageFromCurrentImageContext()!
		#else
		let format = UIGraphicsImageRendererFormat()
		format.scale = scale
		let renderer = UIGraphicsImageRenderer(size: size, format: format)
		return renderer.image { context in
			color.setFill()
			context.fill(CGRect(origin: .zero, size: size))
		}
		#endif
	}
	func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
		let maxRadius = min(size.width, size.height) / 2
		let cornerRadius: CGFloat = if let radius, radius > 0, radius <= maxRadius {
			radius
		} else {
			maxRadius
		}

		let actions = {
			let rect = CGRect(origin: .zero, size: self.size)
			UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
			self.draw(in: rect)
		}

		#if os(watchOS)
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		defer { UIGraphicsEndImageContext() }
		actions()
		return UIGraphicsGetImageFromCurrentImageContext()
		#else
		let format = UIGraphicsImageRendererFormat()
		format.scale = scale
		return UIGraphicsImageRenderer(size: size, format: format).image { _ in
			actions()
		}
		#endif
	}
	func pngBase64String() -> String? {
		return pngData()?.base64EncodedString()
	}
	func jpegBase64String(compressionQuality: CGFloat) -> String? {
		return jpegData(compressionQuality: compressionQuality)?.base64EncodedString()
	}
}
