import UIKit
public extension String {
	///"SGVsbG8gV29ybGQh".base64Decoded = Optional("Hello World!")
	var base64Decoded: String? {
		if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
			return String(data: data, encoding: .utf8)
		}
		let remainder = count % 4
		var padding = ""
		if remainder > 0 {
				padding = String(repeating: "=", count: 4 - remainder)
		}
		guard let data = Data(base64Encoded: self + padding, options: .ignoreUnknownCharacters) else { return nil }
		return String(data: data, encoding: .utf8)
	}
	///"Hello World!".base64Encoded -> Optional("SGVsbG8gV29ybGQh")
	var base64Encoded: String? {
		let plainData = data(using: .utf8)
		return plainData?.base64EncodedString()
	}
	///SwifterSwift: Array of characters of a string.
	var charactersArray: [Character] {
		return Array(self)
	}
	///"sOme vAriable naMe".camelCased -> "someVariableName"
	var camelCased: String {
		let source = lowercased()
		let first = source[..<source.index(after: source.startIndex)]
		if source.contains(" ") {
			let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
			let camel = connected.replacingOccurrences(of: "\n", with: "")
			let rest = String(camel.dropFirst())
			return first + rest
		}
		let rest = String(source.dropFirst())
		return first + rest
	}
	///"Hello 😀".containEmoji -> true
	var containEmoji: Bool {
		// http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
		for scalar in unicodeScalars {
			switch scalar.value {
			case 0x1F600...0x1F64F, // Emoticons
				 0x1F300...0x1F5FF, // Misc Symbols and Pictographs
				 0x1F680...0x1F6FF, // Transport and Map
				 0x1F1E6...0x1F1FF, // Regional country flags
				 0x2600...0x26FF, // Misc symbols
				 0x2700...0x27BF, // Dingbats
				 0xE0020...0xE007F, // Tags
				 0xFE00...0xFE0F, // Variation Selectors
				 0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
				 127_000...127_600, // Various asian characters
				 65024...65039, // Variation selector
				 9100...9300, // Misc items
				 8400...8447: // Combining Diacritical Marks for Symbols
				return true
			default:
				continue
			}
		}
		return false
	}
	///"Hello".firstCharacterAsString -> Optional("H")
	///"".firstCharacterAsString -> nil
	var firstCharacterAsString: String? {
		guard let first else { return nil }
		return String(first)
	}
	///"123abc".hasLetters -> true
	///"123".hasLetters -> false
	var hasLetters: Bool {
		return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
	}
	///"abcd".hasNumbers -> false
	///"123abc".hasNumbers -> true
	var hasNumbers: Bool {
		return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
	}
	///"abc".isAlphabetic -> true
	///"123abc".isAlphabetic -> false
	var isAlphabetic: Bool {
		let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
		let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
		return hasLetters && !hasNumbers
	}
	///"123abc".isAlphaNumeric -> true
	///"abc".isAlphaNumeric -> false
	var isAlphaNumeric: Bool {
		let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
		let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
		let comps = components(separatedBy: .alphanumerics)
		return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
	}
	///"john@doe.com".isValidEmail -> true
	var isValidEmail: Bool {
		// http://emailregex.com/
		let regex =
				"^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
		return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
	}
	///"https://google.com".isValidUrl -> true
	var isValidUrl: Bool {
		return URL(string: self) != nil
	}
	///"https://google.com".isValidSchemedUrl -> true
	///"google.com".isValidSchemedUrl -> false
	var isValidSchemedUrl: Bool {
		guard let url = URL(string: self) else { return false }
		return url.scheme != nil
	}
	///"https://google.com".isValidHttpsUrl -> true
	var isValidHttpsUrl: Bool {
		guard let url = URL(string: self) else { return false }
		return url.scheme == "https"
	}
	///"http://google.com".isValidHttpUrl -> true
	var isValidHttpUrl: Bool {
		guard let url = URL(string: self) else { return false }
		return url.scheme == "http"
	}
	///"file://Documents/file.txt".isValidFileUrl -> true
	var isValidFileUrl: Bool {
		return URL(string: self)?.isFileURL ?? false
	}
	///"123".isNumeric -> true
	///"1.3".isNumeric -> true (en_US)
	///"1,3".isNumeric -> true (fr_FR)
	///"abc".isNumeric -> false
	var isNumeric: Bool {
		let scanner = Scanner(string: self)
		scanner.locale = NSLocale.current
		#if os(Linux) || os(Android) || targetEnvironment(macCatalyst)
		return scanner.scanDecimal() != nil && scanner.isAtEnd
		#else
		return scanner.scanDecimal(nil) && scanner.isAtEnd
		#endif
	}
	///"123".isDigits -> true
	///"1.3".isDigits -> false
	///"abc".isDigits -> false
	var isDigits: Bool {
		return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
	}
	///"Hello".lastCharacterAsString -> Optional("o")
	///"".lastCharacterAsString -> nil
	var lastCharacterAsString: String? {
		guard let last else { return nil }
		return String(last)
	}
	///"1".bool -> true
	///"False".bool -> false
	///"Hello".bool = nil
	var bool: Bool? {
		let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
		switch selfLowercased {
		case "true", "yes", "1":
			return true
		case "false", "no", "0":
			return false
		default:
			return nil
		}
	}
	///"2007-06-29".date -> Optional(Date)
	var date: Date? {
			let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
			let formatter = DateFormatter()
			formatter.timeZone = TimeZone.current
			formatter.dateFormat = "yyyy-MM-dd"
			return formatter.date(from: selfLowercased)
	}
	///"2007-06-29 14:23:09".dateTime -> Optional(Date)
	var dateTime: Date? {
		let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone.current
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return formatter.date(from: selfLowercased)
	}
	///"101".int -> 101
	var int: Int? {
		return Int(self)
	}
	///"https://google.com".url -> URL(string: "https://google.com")
	///"not url".url -> nil
	var url: URL? {
		return URL(string: self)
	}
	///"   hello  \n".trimmed -> "hello"
	var trimmed: String {
		return trimmingCharacters(in: .whitespacesAndNewlines)
	}
	///"it's%20easy%20to%20decode%20strings".urlDecoded -> "it's easy to decode strings"
	var urlDecoded: String {
		return removingPercentEncoding ?? self
	}
	///"it's easy to encode strings".urlEncoded -> "it's%20easy%20to%20encode%20strings"
	var urlEncoded: String {
		return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
	}
	///"   \n Swifter   \n  Swift  ".withoutSpacesAndNewLines -> "SwifterSwift"
	var withoutSpacesAndNewLines: String {
		return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
	}
	var isWhitespace: Bool {
		return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
	}
}
public extension String {
	func float(locale: Locale = .current) -> Float? {
		let formatter = NumberFormatter()
		formatter.locale = locale
		formatter.allowsFloats = true
		return formatter.number(from: self)?.floatValue
	}
	func double(locale: Locale = .current) -> Double? {
		let formatter = NumberFormatter()
		formatter.locale = locale
		formatter.allowsFloats = true
		return formatter.number(from: self)?.doubleValue
	}
	func cgFloat(locale: Locale = .current) -> CGFloat? {
		let formatter = NumberFormatter()
		formatter.locale = locale
		formatter.allowsFloats = true
		return formatter.number(from: self) as? CGFloat
	}
	///"Hello\ntest".lines() -> ["Hello", "test"]
	func lines() -> [String] {
		var result = [String]()
		enumerateLines { line, _ in
			result.append(line)
		}
		return result
	}
	///"SwifterSwift".unicodeArray() -> [83, 119, 105, 102, 116, 101, 114, 83, 119, 105, 102, 116]
	func unicodeArray() -> [Int] {
		return unicodeScalars.map { Int($0.value) }
	}
	///"Swift is amazing".words() -> ["Swift", "is", "amazing"]
	func words() -> [String] {
		let characterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
		let comps = components(separatedBy: characterSet)
		return comps.filter { !$0.isEmpty }
	}
	///"Swift is amazing".wordsCount() -> 3
	func wordCount() -> Int {
		let characterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
		let comps = components(separatedBy: characterSet)
		let words = comps.filter { !$0.isEmpty }
		return words.count
	}
	func copyToPasteboard() {
		#if os(iOS)
		UIPasteboard.general.string = self
		#elseif os(macOS)
		NSPasteboard.general.clearContents()
		NSPasteboard.general.setString(self, forType: .string)
		#endif
	}
	mutating func firstCharacterUppercased() {
		guard let first else { return }
		self = String(first).uppercased() + dropFirst()
	}
	///"Hello World!".contain("O") -> false
	///"Hello World!".contain("o", caseSensitive: false) -> true
	func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
		if !caseSensitive {
			return range(of: string, options: .caseInsensitive) != nil
		}
		return range(of: string) != nil
	}
	///"Hello World!".count(of: "o") -> 2
	///"Hello World!".count(of: "L", caseSensitive: false) -> 3
	func count(of string: String, caseSensitive: Bool = true) -> Int {
		if !caseSensitive {
			return lowercased().components(separatedBy: string.lowercased()).count - 1
		}
		return components(separatedBy: string).count - 1
	}
	///"Hello World!".ends(with: "!") -> true
	///"Hello World!".ends(with: "WoRld!", caseSensitive: false) -> true
	func ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
		if !caseSensitive {
			return lowercased().hasSuffix(suffix.lowercased())
		}
		return hasSuffix(suffix)
	}
	///String.random(ofLength: 18) -> "u7MMZYvGo9obcOcPj8"
	static func random(ofLength length: Int) -> String {
		guard length > 0 else { return "" }
		let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		var randomString = ""
		for _ in 1...length {
			randomString.append(base.randomElement()!)
		}
		return randomString
	}
	@discardableResult
	mutating func reverse() -> String {
		let chars: [Character] = reversed()
		self = String(chars)
		return self
	}
	///"hello World".starts(with: "h") -> true
	///"hello World".starts(with: "H", caseSensitive: false) -> true
	func starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
		if !caseSensitive {
			return lowercased().hasPrefix(prefix.lowercased())
		}
		return hasPrefix(prefix)
	}
}
public extension String {
	var bold: NSAttributedString {
		return NSMutableAttributedString(
				string: self,
				attributes: [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
	}
	var underline: NSAttributedString {
		return NSAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
	}
	var strikethrough: NSAttributedString {
		return NSAttributedString(
				string: self,
				attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)])
	}
	var italic: NSAttributedString {
		return NSMutableAttributedString(
				string: self,
				attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
	}
	func colored(with color: UIColor) -> NSAttributedString {
		return NSMutableAttributedString(string: self, attributes: [.foregroundColor: color])
	}
	var localized: String {
		return NSLocalizedString(self, comment: "")
		//print("login_title".localized)
	}
}
