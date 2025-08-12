//
//  UtilsDownload.swift
//  application_ios
//
//  Created by An Pham Ngoc on 9/14/24.
//

import Foundation
protocol APIDownloadDelegate: NSObjectProtocol {
    func progressValue(_ percent: Float)
    func finishDownload(_ _data: NSData)
    func errorDownload()
}
class APIDownload: NSObject, URLSessionDownloadDelegate {
    var url : URL?
    weak var delegate: APIDownloadDelegate?
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if (delegate != nil) {
            guard let dataFromURL = NSData(contentsOf: location) else {return}
            self.delegate?.finishDownload(dataFromURL)
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if (delegate != nil) {
            self.delegate?.progressValue(Float(bytesWritten / totalBytesWritten))
        }
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if(error != nil) {
			UtilsLogger.log("UtilsDownload", "Download completed with error: \(error!.localizedDescription)")
        }
        if (delegate != nil) {
            self.delegate?.errorDownload()
        }
    }
    func download(url: URL) {
        self.url = url
        let sessionConfig = URLSessionConfiguration.background(withIdentifier: url.absoluteString)
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        sessionConfig.urlCache = nil
        sessionConfig.httpShouldSetCookies = false
        if (Global.USE_BASIC_AUTH) {
            let userPasswordData = "\(Global.AUTH_USERNAME):\(Global.AUTH_PASS)".data(using: .utf8)
            let base64EncodedCredential = userPasswordData!.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
            let authString = "Basic \(base64EncodedCredential)"
            sessionConfig.httpAdditionalHeaders = ["Authorization" : authString]
        }
        let session = Foundation.URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        let task = session.downloadTask(with: url)
        task.resume()
    }
}
