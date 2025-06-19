import UIKit
class APIConnect: NSObject {
    private var responseData: NSMutableData?
    private var dataTask: URLSessionDataTask?
    private var defaultSession: URLSession?
    var strUrlRequest = ""
    var strParam = ""
    var strMethod = ""
    var strAction = ""
    var strTable = ""
    var isRequesting = false
    var callbackLocalDatabase: ((_ response: NSDictionary) -> Void)? = nil
    var callbackComplete: ((_ response: NSDictionary) -> Void)? = nil
    var callbackError: (() -> Void)? = nil
    override init() {
        super.init()
        strMethod = "POST"
        strTable = ""
        strParam = ""
        strUrlRequest = Global.BASE_URL
    }
    func cancel() {
        if (dataTask != nil)  {
            dataTask?.cancel()
            defaultSession?.finishTasksAndInvalidate()
            defaultSession = nil
            dataTask = nil
        }
        isRequesting = false
        if (responseData != nil) {
            let data = NSData(bytes: nil, length: 0)
            responseData?.setData(data as Data)
            responseData?.length = 0
            responseData = nil
        }
    }
    func postDataServer( dic: NSDictionary, localDatabase flag: Bool, withLocalDatabase callLocalDatabase: @escaping (_ response: NSDictionary) -> Void, withComplete callComplete: @escaping (_ response:NSDictionary) -> Void, withError callError: @escaping () -> Void) {
        callbackLocalDatabase = callLocalDatabase
        callbackComplete = callComplete
        callbackError = callError
        cancel()
        isRequesting = true
        if flag == true {
            localDatabase()
        }
        let request = NSMutableURLRequest(url: URL(string: strUrlRequest)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30.0)
        request.httpMethod = strMethod
        let strAuth = "\("MILCountryModel.sharedInstance().key_1"):\("MILCountryModel.sharedInstance().key_2")"
        let authData: Data? = strAuth.data(using: .utf8)
        let authValue = "Basic \(String(describing: authData?.base64EncodedString(options: [])))"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        var userAgent: String = NSString(format:"(%@; %@; Scale/%0.2f)", UIDevice.current.model, UIDevice.current.systemVersion) as String
        if !(userAgent.canBeConverted(to: .ascii)) {
            let mutableUserAgent: String? = userAgent
            if CFStringTransform((mutableUserAgent as! CFMutableString), nil, ("Any-Latin; Latin-ASCII; [:^ASCII:] Remove" as CFString), false) {
                userAgent = mutableUserAgent!
            }
        }
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        if dic != NSNull() {
            let jsonData: Data? = try? JSONSerialization.data(withJSONObject: dic, options: [])
            var json_data:NSString = String(data: jsonData!, encoding: .utf8)! as NSString
            json_data = NSString(format:"json_data=%@", json_data)
            json_data = json_data.replacingOccurrences(of: "+", with: "%2B") as NSString
			UtilsLogger.log(self, "json_data \(String(describing: json_data))")
            let postLength = "\(UInt(json_data.length))"
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = json_data.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)
        }
        let defaultConfigObject = URLSessionConfiguration.default
        defaultConfigObject.timeoutIntervalForRequest = 40
        defaultConfigObject.timeoutIntervalForResource = 65
        
        defaultSession = URLSession(configuration: defaultConfigObject, delegate: self as URLSessionDelegate, delegateQueue: OperationQueue.main)
        dataTask = defaultSession?.dataTask(with: request as URLRequest)
        dataTask?.resume()
    }
    func convertToDictionary(text: String) -> NSDictionary {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return  try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            } catch let error as NSError {
                print(error)
            }
        }
        return [:]
    }
    func localDatabase() {
        if (strTable == "table_setting_items") {
            DispatchQueue.global(qos: .default).async(execute: {() -> Void in
                let strQuery = "SELECT content FROM \(self.strTable)"
                let responseString: String =  PerSQLite.getContentData(strQuery, dbName: "PNA1.db")
                DispatchQueue.main.sync(execute: {() -> Void in
                    if responseString.count > 0 {
                        let dic:NSDictionary = self.convertToDictionary(text: responseString)
                        if self.isRequesting == true {
                            self.callbackLocalDatabase!(dic)
                        }
                    }
                })
            })
        }
    }
    func parseString(responseString: String) {
        let responseString = responseString.replacingOccurrences(of: "<script type=\"text/javascript\">", with: "")
        let dic:NSDictionary = convertToDictionary(text: responseString)
        let status:Int = dic["status"]! as! Int
        if status == -200 {
            callbackError!()
            return
        }
        isRequesting = false
        if (strTable == "table_setting_items") {
            DispatchQueue.global(qos: .default).async(execute: {() -> Void in
                let strQuery = "SELECT * FROM \(self.strTable)"
                if !PerSQLite.isExistQueryData(strQuery, dbName: "PNA1.db") {
					PerSQLite.insert(self.strTable, data: [
                        "content" : responseString
                        ], fields: "content", dbName: "PNA1.db")
                }
                else {
					PerSQLite.update(self.strTable, data: [
                        "content" : responseString
                        ], dbName: "PNA1.db")
                }
            })
        }
        callbackComplete!(dic)
    }
}
extension APIConnect:URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		UtilsLogger.log(self, "urlSession", "didReceive challenge")
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if let err = error {
			UtilsLogger.log(self, "urlSession", "Error: \(err.localizedDescription)")
        } else {
			UtilsLogger.log(self, "urlSession", "Error. Giving up")
        }
    }
}
extension APIConnect:URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
		UtilsLogger.log(self, "urlSession", "didBecome streamTask")
        streamTask.resume()
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
		UtilsLogger.log(self, "urlSession", "didBecome downloadTask")
        downloadTask.resume()
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		UtilsLogger.log(self, "urlSession", "didReceive challenge")
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        if let urlString = request.url?.absoluteString {
			UtilsLogger.log(self, "urlSession", "willPerformHTTPRedirection to \(urlString)")
        } else {
			UtilsLogger.log(self, "urlSession", "willPerformHTTPRedirection")
        }
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let err = error {
			UtilsLogger.log(self, "urlSession", "Error: \(err.localizedDescription)")
        } else {
			UtilsLogger.log(self, "urlSession", "Error. Giving up")
            if let responseText = String(data: responseData! as Data, encoding: .utf8) {
                parseString(responseString: responseText)
            }
        }
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
		UtilsLogger.log(self, "urlSession", "didReceive response")
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		UtilsLogger.log(self, "urlSession", "didReceive data")
        if !(responseData != nil) {
            responseData = NSMutableData()
        }
        responseData?.append(data)
    }
}
