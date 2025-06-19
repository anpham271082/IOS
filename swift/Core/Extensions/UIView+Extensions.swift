import UIKit
public extension UIView {
	enum ShakeDirection {
		///Shake left and right.
		case horizontal
		///Shake up and down.
		case vertical
	}
	enum AngleUnit {
		case degrees
		case radians
	}
	enum ShakeAnimationType {
		case linear
		case easeIn
		case easeOut
		case easeInOut
	}
	struct GradientDirection: Sendable {
		public static let topToBottom = GradientDirection(startPoint: CGPoint(x: 0.5, y: 0.0),
														  endPoint: CGPoint(x: 0.5, y: 1.0))
		public static let bottomToTop = GradientDirection(startPoint: CGPoint(x: 0.5, y: 1.0),
														  endPoint: CGPoint(x: 0.5, y: 0.0))
		public static let leftToRight = GradientDirection(startPoint: CGPoint(x: 0.0, y: 0.5),
														  endPoint: CGPoint(x: 1.0, y: 0.5))
		public static let rightToLeft = GradientDirection(startPoint: CGPoint(x: 1.0, y: 0.5),
														  endPoint: CGPoint(x: 0.0, y: 0.5))

		public let startPoint: CGPoint
		public let endPoint: CGPoint

		public init(startPoint: CGPoint, endPoint: CGPoint) {
			self.startPoint = startPoint
			self.endPoint = endPoint
		}
	}

	@IBInspectable var layerBorderColor: UIColor? {
		get {
			guard let color = layer.borderColor else { return nil }
			return UIColor(cgColor: color)
		}
		set {
			guard let color = newValue else {
				layer.borderColor = nil
				return
			}
			// Fix React-Native conflict issue
			guard String(describing: type(of: color)) != "__NSCFType" else { return }
			layer.borderColor = color.cgColor
		}
	}

	@IBInspectable var layerBorderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}

	@IBInspectable var layerCornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.masksToBounds = true
			layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
		}
	}

	@IBInspectable var layerShadowColor: UIColor? {
		get {
			guard let color = layer.shadowColor else { return nil }
			return UIColor(cgColor: color)
		}
		set {
			layer.shadowColor = newValue?.cgColor
		}
	}

	@IBInspectable var layerShadowOffset: CGSize {
		get {
			return layer.shadowOffset
		}
		set {
			layer.shadowOffset = newValue
		}
	}

	@IBInspectable var layerShadowOpacity: Float {
		get {
			return layer.shadowOpacity
		}
		set {
			layer.shadowOpacity = newValue
		}
	}

	@IBInspectable var layerShadowRadius: CGFloat {
		get {
			return layer.shadowRadius
		}
		set {
			layer.shadowRadius = newValue
		}
	}

	@IBInspectable var masksToBounds: Bool {
		get {
			return layer.masksToBounds
		}
		set {
			layer.masksToBounds = newValue
		}
	}
	
	func addSubviews(_ subviews: [UIView]) {
		subviews.forEach { addSubview($0) }
	}
	func removeSubviews() {
		subviews.forEach { $0.removeFromSuperview() }
	}
	func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
		let maskPath = UIBezierPath(
			roundedRect: bounds,
			byRoundingCorners: corners,
			cornerRadii: CGSize(width: radius, height: radius))

		let shape = CAShapeLayer()
		shape.path = maskPath.cgPath
		layer.mask = shape
	}
	func makeCircle(diameter: CGFloat) {
		clipsToBounds = true
		bounds.size.height = diameter
		bounds.size.width = diameter
		layer.cornerRadius = diameter / 2
	}
	func addShadow(
		ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0),
		radius: CGFloat = 3,
		offset: CGSize = .zero,
		opacity: Float = 0.5) {
		layer.shadowColor = color.cgColor
		layer.shadowOffset = offset
		layer.shadowRadius = radius
		layer.shadowOpacity = opacity
		layer.masksToBounds = false
	}
	func blur(withStyle style: UIBlurEffect.Style = .light) {
		let blurEffect = UIBlurEffect(style: style)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
		addSubview(blurEffectView)
		clipsToBounds = true
	}
	func removeBlur() {
		subviews
			.lazy
			.compactMap { $0 as? UIVisualEffectView }
			.filter { $0.effect is UIBlurEffect }
			.forEach { $0.removeFromSuperview() }
	}
	func fadeIn(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
	   if isHidden {
		   isHidden = false
	   }
	   UIView.animate(withDuration: duration, animations: {
		   self.alpha = 1
	   }, completion: completion)
   }
	func fadeOut(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
		if isHidden {
			isHidden = false
		}
		UIView.animate(withDuration: duration, animations: {
			self.alpha = 0
		}, completion: completion)
	}
	func scale(by offset: CGPoint, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
		if animated {
			UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: { () in
				self.transform = self.transform.scaledBy(x: offset.x, y: offset.y)
			}, completion: completion)
		} else {
			transform = transform.scaledBy(x: offset.x, y: offset.y)
			completion?(true)
		}
	}
	func shake(
		direction: ShakeDirection = .horizontal,
		duration: TimeInterval = 1,
		animationType: ShakeAnimationType = .easeOut,
		completion: (() -> Void)? = nil) {
		CATransaction.begin()
		let animation = switch direction {
		case .horizontal:
			CAKeyframeAnimation(keyPath: "transform.translation.x")
		case .vertical:
			CAKeyframeAnimation(keyPath: "transform.translation.y")
		}
		switch animationType {
		case .linear:
			animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
		case .easeIn:
			animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
		case .easeOut:
			animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
		case .easeInOut:
			animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
		}
		CATransaction.setCompletionBlock(completion)
		animation.duration = duration
		animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
		layer.add(animation, forKey: "shake")
		CATransaction.commit()
	}
	func rotate(byAngle angle: CGFloat, ofType type: AngleUnit, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
		let angleWithType = (type == .degrees) ? .pi * angle / 180.0 : angle
		let aDuration = animated ? duration : 0
		UIView.animate(withDuration: aDuration, delay: 0, options: .curveLinear, animations: { () in
			self.transform = self.transform.rotated(by: angleWithType)
		}, completion: completion)
	}
	func rotate(toAngle angle: CGFloat, ofType type: AngleUnit, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
		let angleWithType = (type == .degrees) ? .pi * angle / 180.0 : angle
		let currentAngle = atan2(transform.b, transform.a)
		let aDuration = animated ? duration : 0
		UIView.animate(withDuration: aDuration, animations: {
			self.transform = self.transform.rotated(by: angleWithType - currentAngle)
		}, completion: completion)
	}
	func addGradient(colors: [UIColor], locations: [CGFloat] = [0.0, 1.0], direction: GradientDirection) {
			let gradientLayer = CAGradientLayer()
			gradientLayer.frame = bounds
			gradientLayer.colors = colors.map(\.cgColor)
			gradientLayer.locations = locations.map { NSNumber(value: $0) }
			gradientLayer.startPoint = direction.startPoint
			gradientLayer.endPoint = direction.endPoint
			layer.addSublayer(gradientLayer)
		}
}
