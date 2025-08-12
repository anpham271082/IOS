import Foundation
public extension Dictionary {
	///let dict: [String: Any] = ["testKey": "testValue", "testArrayKey": [1, 2, 3, 4, 5]]
	///dict.has(key: "testKey") -> true
	///dict.has(key: "anotherKey") -> false
	func has(key: Key) -> Bool {
		return index(forKey: key) != nil
	}
	///var dict : [String: String] = ["key1" : "value1", "key2" : "value2", "key3" : "value3"]
	///dict.removeAll(keys: ["key1", "key2"])
	///dict.keys.contains("key3") -> true
	///dict.keys.contains("key1") -> false
	///dict.keys.contains("key2") -> false
	mutating func removeAll(keys: some Sequence<Key>) {
		keys.forEach { removeValue(forKey: $0) }
	}
	@discardableResult
	mutating func removeValueForRandomKey() -> Value? {
		guard let randomKey = keys.randomElement() else { return nil }
		return removeValue(forKey: randomKey)
	}
	func jsonData(prettify: Bool = false) -> Data? {
		guard JSONSerialization.isValidJSONObject(self) else {
			return nil
		}
		let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization
			.WritingOptions()
		return try? JSONSerialization.data(withJSONObject: self, options: options)
	}
	
	///dict.jsonString() -> "{"testKey":"testValue","testArrayKey":[1,2,3,4,5]}"
	///dict.jsonString(prettify: true)
	///"{
	///		"testKey" : "testValue",
	///		"testArrayKey" : [
	///     	1,
	///     	2,
	///     	3,
	///     	4,
	///     	5
	/// 	]
	/// }"
	func jsonString(prettify: Bool = false) -> String? {
		guard JSONSerialization.isValidJSONObject(self) else { return nil }
		let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization
			.WritingOptions()
		guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
		return String(data: jsonData, encoding: .utf8)
	}
	///var dict =  ["key1": 1, "key2": 2, "key3": 3, "key4": 4]
	///dict.pick(keys: ["key1", "key3", "key4"]) -> ["key1": 1, "key3": 3, "key4": 4]
	///dict.pick(keys: ["key2"]) -> ["key2": 2]
	func pick(keys: [Key]) -> [Key: Value] {
		keys.reduce(into: [Key: Value]()) { result, item in
			result[item] = self[item]
		}
	}
}
public extension Dictionary where Key: StringProtocol {
	///var dict = ["tEstKeY": "value"]
	///dict.lowercaseAllKeys()
	///print(dict) // prints "["testkey": "value"]"
	mutating func lowercaseAllKeys() {
		for key in keys {
			if let lowercaseKey = String(describing: key).lowercased() as? Key {
				self[lowercaseKey] = removeValue(forKey: key)
			}
		}
	}
}
public extension Dictionary {
	///let dict: [String: String] = ["key1": "value1"]
	///let dict2: [String: String] = ["key2": "value2"]
	///let result = dict + dict2
	///result["key1"] -> "value1"
	///result["key2"] -> "value2"
	static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
		var result = lhs
		rhs.forEach { result[$0] = $1 }
		return result
	}
	///var dict: [String: String] = ["key1": "value1"]
	///let dict2: [String: String] = ["key2": "value2"]
	///dict += dict2
	///dict["key1"] -> "value1"
	///dict["key2"] -> "value2"
	static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
		rhs.forEach { lhs[$0] = $1 }
	}
	///let dict: [String: String] = ["key1": "value1", "key2": "value2", "key3": "value3"]
	///let result = dict-["key1", "key2"]
	///result.keys.contains("key3") -> true
	///result.keys.contains("key1") -> false
	///result.keys.contains("key2") -> false
	static func - (lhs: [Key: Value], keys: some Sequence<Key>) -> [Key: Value] {
		var result = lhs
		result.removeAll(keys: keys)
		return result
	}
	///var dict: [String: String] = ["key1": "value1", "key2": "value2", "key3": "value3"]
	///dict-=["key1", "key2"]
	///dict.keys.contains("key3") -> true
	///dict.keys.contains("key1") -> false
	///dict.keys.contains("key2") -> false
	static func -= (lhs: inout [Key: Value], keys: some Sequence<Key>) {
		lhs.removeAll(keys: keys)
	}
}
