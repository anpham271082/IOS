import Foundation
class Tutorial1: NSObject {
	class func test(){
		///define 2 variables => a tuple
		let (x, y) = (2, 4)
		//print("x = \(x), y = \(y)") -> x = 2, y = 4
		
		var names:[String] = ["John", "Jack", "Tim", "Elon" ]
		for i in 0..<names.count {
			///print("\(i) - \(names[i])") -> "John", "Jack", "Tim", "Elon"
		}
		for i in 0...2 {
			//print("\(i) - \(names[i])") -> "John", "Jack", "Tim"
		}
		
		let someOtherFriends = ["Anna", "Taylor"]
		names += someOtherFriends
		names.insert("Hoang", at: names.count)
		///print(names) -> ["John", "Jack", "Tim", "Elon", "Anna", "Taylor", "Hoang"]
		
		///iterate with index
		for (index, name) in names.enumerated() {
			///print("index: \(index), name: \(name)")
		}
		
		var filteredNames = names.filter { name in
			return name.lowercased() == "anna"
		}
		///print(filteredNames) -> "Anna"
		
		filteredNames = names.filter{ name in
			return name.count > 4
		}
		///print(filteredNames) -> "Taylor", "Hoang"
		
		//now delete element with name = "Taylor"
		names = names.filter {name in
			return name.lowercased() != "taylor"
		}
		///print(names) -> ["John", "Jack", "Tim", "Elon", "Anna", "Hoang"]
		
		let someNumbers: [CGFloat] = [2, 5, 6, 7, 8, 9]
		let squaredNumbers = someNumbers.map {
			return Int(pow($0, 2))
		}
		///print(squaredNumbers) -> [4, 25, 36, 49, 64, 81]
		
		var reversedNames = names.sorted {
			return $1 < $0
		}
		///print(reversedNames) -> ["Tim", "John", "Jack", "Hoang", "Elon", "Anna"]
		
		var fruits:Set<String> = ["Orange", "Lemon", "Pineapple", "Apple", "Kiwi"]
		fruits.insert("Apple")//you cannot add the same value to a "set"
		///print(fruits) -> ["Orange", "Kiwi", "Pineapple", "Apple", "Lemon"]
		for (i, fruit) in fruits.enumerated() {
			//print("i = \(i), fruit: \(fruit)")
		}
		
		let setA:Set<Int> = [1, 3, 4, 5, 6, 9]
		let setB:Set<Int> = [15, 23, 4, 5, 88, 77]
		///print(setA.intersection(setB)) -> [4, 5]
		///print("differences: \(setA.symmetricDifference(setB))") -> random [1, 23, 3, 88, 77, 9, 15, 6] ... [23, 3, 9, 77, 6, 88, 15, 1]
		///print("union: \(setA.union(setB))") -> random [6, 4, 9, 23, 88, 77, 15, 1, 5, 3] ... [1, 9, 3, 4, 5, 23, 15, 77, 6, 88]
		///print("count: \(setA.union(setB).count)") -> 10
		
		var user:[String: Any] = [
			"name": "Hoang",
			"age": 18,
			"email": "sunlight4d@gmail.com"
		]
		user["address"] = "Bach Mai street, Hanoi, Vietnam"
		user["email"] = nil //remove a key(property)
		
		if let oldAge = user.updateValue(20, forKey: "age") {
			///print("The old value of age is: \(oldAge)") -> 18
		}
		
		for (key, value) in user {
			//print("key = \(key), value = \(value)")
		}
		///print(user.keys) -> ["age", "address", "name"]
		///print(user.values) -> [20, "Bach Mai street, Hanoi, Vietnam", "Hoang"]
		
		let marks:Float = 9.0
		switch marks {
		case 0:
			print("very bad, you do nothing")
		case 0..<4:
			print("Quite bad")
		case 4..<5:
			print("You must work harder to pass this Exam")
		case 5..<7:
			print("Normal")
		case 7..<9:
			print("Good")
		case 9...10:
			print("Excellent")
		default:
			print("Not a valid mark")
		}
		
		let point = (4, 5) //this is a tuple
		switch point {
		case let (x, y) where x < 0 && y < 0:
			print("x < 0 and y < 0")
		case let (x, y) where x > 0 && y > 0:
			print("x > 0 and y > 0")
			//fallthrough
		case let (x, y) where x == 0 && y == 0:
			print("x = 0 and y = 0")
			//let's write other cases
		default:
			print("I donot know")
		}
	}
}
