import Foundation
class Tutorial2: NSObject {
	class func test(){
		func determineHigherValue<T: Comparable> (valueOne: T, valueTwo: T) {
			let higherValue = valueOne > valueTwo ? valueOne: valueTwo
			print("\(higherValue) is the higher value")
		}
		///determineHigherValue(valueOne: "abc", valueTwo:"def")
		///determineHigherValue(valueOne: 7, valueTwo:5)
		///determineHigherValue(valueOne: Date.now, valueTwo: Date.distantFuture)
		
        enum MarkLevel {
            case bad, normal, good, veryGood, excellent, unknown
        }
        func getMark(_ mark: Float) -> MarkLevel {
            if mark < 5 && mark >= 0 {
                return MarkLevel.bad
            } else if mark >= 5 && mark < 6 {
                return MarkLevel.normal
            } else if mark >= 6 && mark < 7 {
                return .good
            } else if mark >= 7 && mark < 9 {
                return .veryGood
            } else if mark >= 9 && mark <= 10 {
                return .excellent
            }
            return .unknown
        }
        
        func startEnd(numbers: [Float]) -> (start: Float, end: Float) {
            var currentStart:Float = 0.0
            var currentEnd:Float = 0.0
            if numbers.count == 1 {
                currentStart = numbers[0]
                currentEnd = numbers[0]
            } else if numbers.count > 1 {
                currentStart = numbers[0]
                currentEnd = numbers[numbers.count - 1]
            }
            return (currentStart, currentEnd)
        }
        ///print(startEnd(numbers: [4.5, 6.8, 9.3, 2.4])) -> (start: 4.5, end: 2.4)
        
        func getTotal(numbers: Double...) -> Double {
            var total:Double = 0.0
            for number in numbers {
                total += number
            }
            return total
        }
        ///print(getTotal(numbers: 1, 3, 5, 7, 9)) -> 25.0
        
        func changeSomething(xx: inout Int) {
            xx = 12
        }
        var aa = 33
        changeSomething(xx: &aa)
        ///print(aa) -> 12
        
		func doSomeBigTasks(input x: Int, completion: (String) -> Void, onFailure: (String) -> Void) {
            if(x == 10) {
                completion("This is result")
            } else {
                onFailure("Result failed")
            }
        }
        doSomeBigTasks(input: 22) { stringResult in
            print(stringResult)
        } onFailure: { errorResult in
            print(errorResult)
        }
        
        var rect1 = Rectangle(width: 100, height: 200)
        var rect4 = Rectangle(width: 123, height: 456)
        ///print(rect4.area) -> 56088.0
        if rect1 == rect4 {
            print("rect1 and rect4 has the same contents")
        }
        
        var point1 = Point(x: 10, y: 20)
        var point2 = Point(x: 30, y: 50)
        ///print(point1.toString()) -> x = 10.0, y = 20.0
        ///print("Distance between p1 and p2 : \(point1.distanceTo(point: point2))") -> 36.06
        point2.moveTo(x: 99, y: 88)
        
        var mySwitch = OnOffSwitch.on
        mySwitch.press()
        print(mySwitch)
        
        var planet1 = Planet[0]
        var planet3 = Planet[4]
        print(planet3)
        
        //Asynchronous Functions
        let urlGetRandomUser = URL(string: "https://randomuser.me/api")
        let urlGetDetailCountry = URL(string: "https://api.zippopotam.us/us/33162")
        print("begin task 1")
        URLSession.shared.dataTask(with: urlGetRandomUser!) {(data, response, error) in
            print("finished get task 1")
        }.resume()
        print("begin task 2")
        URLSession.shared.dataTask(with: urlGetDetailCountry!) {(data, response, error) in
            print("finished get task 2")
        }.resume()

        func do2Tasks() async {
            do {
                print("begin task 1")
                let (data1, response1) = try await URLSession.shared.data(from: urlGetRandomUser!)
                print("finished task 1")
                print("begin task 2")
                let (data2, response2) = try await URLSession.shared.data(from: urlGetDetailCountry!)
                print("finished task 2")
            }catch {
                
            }
        }
    }
}
struct Rectangle:Equatable {
    var width: Double
    var height: Double
    var _color: String = ""
    //calculated property
    var area: Double {
        get {
            return width * height
        }
    }
    var color: String {
        get {
            return _color
        }
        set(value) {
            _color = value
        }
    }
    static func == (rectA: Rectangle, rectB: Rectangle) -> Bool {
        return rectA.width == rectB.width
                && rectA.height == rectB.height
    }
}
struct Direction {
    static let north = "north"
    static let east = "east"
    static let west = "west"
    static let south = "south"
}

struct Point {
    var x = 0.0, y = 0.0
    func toString() -> String {
        return "x = \(x), y = \(y)"
    }
    func distanceTo(point: Point) -> Double {
        let result: Double = sqrt(pow(self.x - point.x, 2)
                                  + pow(self.y - point.y, 2))
        return Double(round(result * 100) / 100)
    }
    mutating func moveTo(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}
enum OnOffSwitch {
    case on, off
    mutating func press() {
        self = self == .on ? .off : .on
    }
}

struct Planet {
    private static let planets:[String] = ["mercury", "venus", "earth", "mars", "jupiter", "saturn", "uranus", "neptune"]
    static subscript(i: Int) -> String {
        return planets[i]
    }
}
class Vehicle {
    //? = can be null
    var speed: Double?
    var color:String?
    //default constructor
    init() {
        speed = 0.0
        color = "white"
    }
    //calculated property
    var description: String {
        //?? = default value
        "Speed: \(speed ?? 0.0), color: \(color ?? "white")"
    }
    init(speed: Double, color: String) {
        self.speed = speed
        self.color = color
    }
}
let vehicle1 = Vehicle(speed: 12, color: "green")

//child/sub class
class Bicycle: Vehicle {
    var hasBaskit:Bool = true
    var brandName: String?
    //failable initializer
    convenience init?(speed: Double, color: String,
                      hasBaskit: Bool, brandName:String) {
        if brandName.isEmpty {
            return nil
        }
        self.init(speed: speed, color: color)
        self.hasBaskit = hasBaskit
        self.brandName = brandName
    }
    //Initializer Parameters Without Argument Labels
    convenience init(_ speed: Double,_ color: String,_ hasBaskit: Bool) {
        self.init(speed: speed, color: color)
        self.hasBaskit = hasBaskit
    }
}
class Department {
    var id:Int
    var departmentName: String
    init(departmentId id: Int, departmentName: String) {
        self.id = id
        self.departmentName = departmentName
    }
}
class Employee {
    var id: Int
    var employeeName: String
    var department:Department? //The employee may be in a department or NOT
    init(employeeId id: Int, employeeName: String,
         department: Department?) {
        self.id = id
        self.employeeName = employeeName
        self.department = department
    }
}
let departmentSales:Department = Department(departmentId: 11, departmentName: "Sales and Marketing")

let mrJohn:Employee = Employee(employeeId: 22, employeeName: "John", department: nil)
//print("mr John's department: \(mrJohn.department?.departmentName)")
//You can use default value
//print("mr John's department: \(mrJohn.department?.departmentName ?? "no department")")

//error handling
enum CalculationError: Error {
    case divideByZero(message: String)
    case valueTooBig(message:String, maximum: Double)
    //other case....
}
func divide2Numbers(number1: Double, number2: Double) throws -> Double {
    if number2 == 0 {
        throw CalculationError.divideByZero(message: "Cannot divide by zero")
        //you can customize your error object here
    }
    guard number1 < 1_000_000 && number2 < 1_000_000 else {
        throw CalculationError.valueTooBig(message: "Value is too big", maximum: 1_000_000)
    }
    return number1 / number2
}
/*do {
    //try print("3 / 0 is : \(divide2Numbers(number1: 3, number2: 0))")
    try print("3000000 / 1000000 is : \(divide2Numbers(number1: 3000000, number2: 1000000))")
} catch CalculationError.valueTooBig(let message,let maximum) {
    print("Reason: \(message), maximum: \(maximum)")
}*/

