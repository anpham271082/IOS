import Foundation
class Tutorial3: NSObject {
	class func test(){
		let appPortfolio = [IndieApp (name: "Creator View", monthlyPrice: 11.99, users: 4356),
							IndieApp(name: "FitHero", monthlyPrice: 0.00, users: 1756),
							IndieApp(name: "Buckets", monthlyPrice: 3.99, users: 7598),
							IndieApp(name: "Connect Four", monthlyPrice: 1.99, users: 34081)]
		let freeApps = appPortfolio.filter { $0.monthlyPrice == 0.00 }
		///print(freeApps) -> [my_app_ios.IndieApp(name: "FitHero", monthlyPrice: 0.0, users: 1756)]
		var highUsers: [IndieApp] = []
		for app in appPortfolio {
			if app.users > 5000 {
				highUsers.append(app)
			}
		}
		let appNames = appPortfolio.map{$0.name}.sorted()
		///print(appNames) -> ["Buckets", "Connect Four", "Creator View", "FitHero"]
		let numbers = [3, 5, 9 , 8, 12]
		let sum1 = numbers.reduce(100, +);
		///print(sum1) -> 137
		let sum2 = numbers.reduce(100, -);
		///print(sum2) -> 63
		let totalUsers = appPortfolio.reduce(0, {$0 + $1.users})
		///print(totalUsers) -> 47791
		
		let arrayOfArrays: [[Int]] = [[1, 2, 3],
									  [7, 8, 9],
									  [4, 5, 6]]
		let singleArray = arrayOfArrays.flatMap { $0 }
		///print(singleArray) -> [1, 2, 3, 7, 8, 9, 4, 5, 6]
		
		
		var swiftUIDevs: Set = ["Sean", "James"]
		var swiftDevs: Set = ["Sean", "James", "Olivia", "Maya", "Leo"]
		var kotlinDevs: Set = ["Olivia", "Elijah", "Leo", "Maya", "Dan"]
		var experiencedDevs: Set = ["Sean", "Ava", "Olivia", "Leo"]
  
		let experiencedSwiftUIDevs = swiftUIDevs.intersection(experiencedDevs)
		//print(experiencedSwiftUIDevs) -> ["Sean"]
  
		let jrSwiftDev = swiftDevs.subtracting(experiencedDevs)
		//print(jrSwiftDev) -> ["Maya", "James"]
  
		swiftUIDevs.isDisjoint(with:swiftDevs)
		//print(swiftUIDevs) -> ["Sean", "James"]
		
		
		swiftDevs.union(swiftDevs)
		//print(swiftDevs) -> ["Sean", "Maya", "James", "Leo", "Olivia"]

		let specialists = swiftDevs.symmetricDifference(kotlinDevs)
		//print(specialists) -> ["Sean", "Dan", "James", "Elijah"]
  
		swiftUIDevs.isSubset(of: kotlinDevs)/// false
  
		swiftDevs.isSuperset (of: swiftUIDevs)///true
 
		swiftDevs.insert("Joe")
		swiftDevs.remove("Sean")
		swiftDevs.contains("Maya")
  
	}
}
struct IndieApp {
	let name: String
	let monthlyPrice: Double
	let users: Int
}

