import UIKit
import Foundation
import SystemConfiguration
import Alamofire
extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}
class APIAlamofire: NSObject {
    static let sharedInstance = APIAlamofire()
    var totalErrorDisplay: Int = 0
    override init() {
    }
    func isConnectedToNetwork() -> Bool {
        guard let flags = getFlags() else { return false }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    func getFlags() -> SCNetworkReachabilityFlags? {
        guard let reachability = ipv4Reachability() ?? ipv6Reachability() else {
            return nil
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(reachability, &flags) {
            return nil
        }
        return flags
    }
    func ipv6Reachability() -> SCNetworkReachability? {
        var zeroAddress = sockaddr_in6()
        zeroAddress.sin6_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin6_family = sa_family_t(AF_INET6)
        return withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
    }
    func ipv4Reachability() -> SCNetworkReachability? {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        return withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
    }
    func uploadImage(_url: String, image: UIImage, _completeHandle: @escaping (_ result: AnyObject?, _ code: Int) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.9) else {
            return
        }
        let headers: HTTPHeaders = [
                "Content-type": "multipart/form-data"
            ]
        AF.upload(multipartFormData:
                    { multipartFormData in
                        multipartFormData.append(data, withName: "photo" , fileName: "photo.jpg", mimeType: "image/jpeg")
                    },to: _url, method: .post , headers: headers)
                    .response { resp in
                            print(resp)
                        }
    }
    func postMethod() {
        let params: Parameters = [
            "name": "Jack",
            "salary": "3540",
            "age": "23"
        ]
        
        AF.request("http://dummy.restapiexample.com/api/v1/create", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).validate(statusCode: 200 ..< 299).responseData { response in
            switch response.result {
                case .success(let data):
                    do {
                        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                            print("Error: Cannot convert data to JSON object")
                            return
                        }
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            print("Error: Could print JSON in String")
                            return
                        }
                
                        print(prettyPrintedJson)
                    } catch {
                        print("Error: Trying to convert JSON data to string")
                        return
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    func getMethod() {
        AF.request("http://dummy.restapiexample.com/api/v1/employees", parameters: nil, headers: nil).validate(statusCode: 200 ..< 299).responseData { response in
            switch response.result {
                case .success(let data):
                    do {
                        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                            print("Error: Cannot convert data to JSON object")
                            return
                        }
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            print("Error: Could print JSON in String")
                            return
                        }
                        
                        print(prettyPrintedJson)
                    } catch {
                        print("Error: Trying to convert JSON data to string")
                        return
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    func putMethod() {
        let params: Parameters = [
            "name": "Nicole",
            "job": "iOS Developer"
        ]
        
        AF.request("https://reqres.in/api/users/2", method: .put, parameters: params, headers: nil).validate(statusCode: 200 ..< 299).responseData { response in
            switch response.result {
                case .success(let data):
                    do {
                        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                            print("Error: Cannot convert data to JSON object")
                            return
                        }
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            print("Error: Could print JSON in String")
                            return
                        }
                        
                        print(prettyPrintedJson)
                    } catch {
                        print("Error: Trying to convert JSON data to string")
                        return
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    func deleteMethod() {
        AF.request("https://my-json-server.typicode.com/typicode/demo/posts/1", method: .delete, parameters: nil, headers: nil).validate(statusCode: 200 ..< 299).responseData { response in
            switch response.result {
                case .success(let data):
                    do {
                        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                            print("Error: Cannot convert data to JSON object")
                            return
                        }
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            print("Error: Could print JSON in String")
                            return
                        }

                        print(prettyPrintedJson)
                    } catch {
                        print("Error: Trying to convert JSON data to string")
                        return
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    func receiveData(_url: String, _method: Int = Global.NETWORK_METHOD_POST, _param: [String: Any]? = nil, _showProgress: Bool = false, listHash: [String] = [], usePrivate: Bool = false, ignoreReturn:Bool = false, _completeHandle: @escaping (_ result: AnyObject?, _ code: Int, _ message: String) -> Void) {
        if (!self.isConnectedToNetwork()) {
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let headers: HTTPHeaders = [
                "Content-type": "multipart/form-data"
            ]
        var methodHttp: HTTPMethod = .get
        switch _method {
        case Global.NETWORK_METHOD_GET:
            methodHttp = .get
            break
        case Global.NETWORK_METHOD_POST:
            methodHttp = .post
            break
        case Global.NETWORK_METHOD_PUT:
            methodHttp = .put
            break
        case Global.NETWORK_METHOD_DELETE:
            methodHttp = .delete
            break
        default:
            break
        }
        AF.request(_url, method: methodHttp, parameters: _param, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON(completionHandler: { response in
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        switch response.result {
                            case .success:
                                do {
                                    let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                    _completeHandle(jsonResult, Global.API_CODE_SUCCESS, "")
                                } catch {
                                    _completeHandle (nil, Global.API_CODE_ERROR, "")
                                }
                                break
                            case .failure:
                                _completeHandle (nil, Global.API_CODE_ERROR, "")
                                if (ignoreReturn) {
                                    return
                                }
                                break
                        }
                        /*switch response.result {
                            case .success:
                                do {
                                    let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                    let returnCode: Int! = jsonResult.object(forKey: "status") as! Int
                                    switch returnCode {
                                    case Global.RETURN_CODE_SUCCESS:
                                        _completeHandle(jsonResult.object(forKey: "data") as AnyObject, Global.API_CODE_SUCCESS, "")
                                        break
                                    case Global.RETURN_CODE_BAD_REQ:
                                        _completeHandle(nil, Global.API_CODE_BAD_REQ, (jsonResult.object(forKey: "message") as? String)!)
                                        break
                                    case Global.RETURN_CODE_BAD_FOR:
                                        _completeHandle(nil, Global.API_CODE_BAD_REQ, (jsonResult.object(forKey: "message") as? String)!)
                                        break
                                    case Global.RETURN_CODE_NOT_ACCEPT:
                                        _completeHandle (nil, Global.API_CODE_ERROR, "")
                                        break
                                    case Global.RETURN_CODE_LOCKED:
                                        _completeHandle (nil, Global.API_CODE_ERROR, "")
                                        break
                                    case Global.RETURN_CODE_EXPIRE_TOKEN:
                                        _completeHandle (nil, Global.API_CODE_EXPIRE, "")
                                        break
                                    default:
                                        _completeHandle (nil, Global.API_CODE_ERROR, "")
                                        break
                                    }
                                } catch {
                                    _completeHandle (nil, Global.API_CODE_ERROR, "")
                                }
                                break
                            case .failure:
                                _completeHandle (nil, Global.API_CODE_ERROR, "")
                                if (ignoreReturn) {
                                    return
                                }
                                break
                        }*/
                    })
    }
}
