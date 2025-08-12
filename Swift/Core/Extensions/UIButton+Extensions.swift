import UIKit
extension UIButton {
	@IBInspectable
	var imageForFocused: UIImage? {
	   get { image(for: .focused) }
	   set { setImage(newValue, for: .focused) }
	}
	
	@IBInspectable
	var titleColorForDisabled: UIColor? {
	   get { titleColor(for: .disabled) }
	   set { setTitleColor(newValue, for: .disabled) }
	}
	
	@IBInspectable
	var titleColorForHighlighted: UIColor? {
	   get { titleColor(for: .highlighted) }
	   set { setTitleColor(newValue, for: .highlighted) }
	}
	
	@IBInspectable
	var titleColorForNormal: UIColor? {
	   get { titleColor(for: .normal) }
	   set { setTitleColor(newValue, for: .normal) }
	}
	
	@IBInspectable
	var titleColorForSelected: UIColor? {
	   get { titleColor(for: .selected) }
	   set { setTitleColor(newValue, for: .selected) }
	}

	@IBInspectable
	var titleColorForFocused: UIColor? {
	   get { titleColor(for: .focused) }
	   set { setTitleColor(newValue, for: .focused) }
	}

	@IBInspectable
	var titleForDisabled: String? {
	   get { title(for: .disabled) }
	   set { setTitle(newValue, for: .disabled) }
	}

	@IBInspectable
	var titleForHighlighted: String? {
	   get { title(for: .highlighted) }
	   set { setTitle(newValue, for: .highlighted) }
	}

	@IBInspectable
	var titleForNormal: String? {
	   get { title(for: .normal) }
	   set { setTitle(newValue, for: .normal) }
	}

	@IBInspectable
	var titleForSelected: String? {
	   get { title(for: .selected) }
	   set { setTitle(newValue, for: .selected) }
	}

	@IBInspectable
	var titleForFocused: String? {
	   get { title(for: .focused) }
	   set { setTitle(newValue, for: .focused) }
	}
	
    var substituteFontName : String {
        get { return (self.titleLabel?.font.fontName)! }
        set { self.titleLabel?.font = UIFont(name: newValue, size: (self.titleLabel?.font.pointSize)!) }
    }
    
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func alignImageAndTitleVertically(padding: CGFloat = 6.0) {
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )
        
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }
}
