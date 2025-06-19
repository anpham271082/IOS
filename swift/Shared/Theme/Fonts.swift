//
//  Global.swift
//  application_ios
//
//  Created by An Pham Ngoc on 9/13/24.
//

import Foundation
enum FontName {
	static let primary = "HelveticaNeue"
	static let bold = "HelveticaNeue-Bold"
	static let italic = "HelveticaNeue-Italic"
}
enum FontStyle {
	case title
	case subtitle
	case body
	case caption
	case button

	var font: UIFont {
		switch self {
		case .title:
			return UIFont(name: FontName.bold, size: 24)!
		case .subtitle:
			return UIFont(name: FontName.primary, size: 18)!
		case .body:
			return UIFont(name: FontName.primary, size: 16)!
		case .caption:
			return UIFont(name: FontName.italic, size: 12)!
		case .button:
			return UIFont(name: FontName.bold, size: 16)!
		}
	}
}
