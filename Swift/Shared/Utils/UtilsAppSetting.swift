//
//  AppSettings.swift
//  application_ios
//
//  Created by An Pham Ngoc on 9/14/24.
//

import Foundation
import SSZipArchive
struct UtilsAppSetting{
    static public func forceUpdateNewVersion() {
        guard let url = URL(string : Global.ITUNES_URL + Global.APP_ID) else {
            return
        }
        guard #available(iOS 10, *) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    static public func isFirstUsingApp () -> Bool {
        let firstUsing = UserDefaults.standard.value(forKey: "firstUsing") as? Bool
        return (firstUsing == nil)
    }
    static public func setFirstUsingApp () {
        UserDefaults.standard.set(false, forKey: "firstUsing")
    }
    static public func buildVersionNumber() -> String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    static public func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return ""
    }
    static public func getConfigForKey (_ key: String) -> String {
        /*
        if let config = UserDefaults.standard.value(forKey: key) as? String {
            return config
        }
        */
        if let receivedData = PerKeychain.load(key: key) {
            let str = PerKeychain.NSDATAtoString(data: receivedData)
            let strDecode = try! str.aesDecryptAES256(key: Global.EN_KEY, iv: Global.EN_IV)
            return strDecode
        }
        return ""
    }
    static public func setConfigForKey (_ key: String, _ value: String) {
        //UserDefaults.standard.set(value, forKey: key)
        let strEncode = try! value.aesEncryptAES256(key: Global.EN_KEY, iv: Global.EN_IV)
        let data = PerKeychain.stringToNSDATA(string: strEncode)
        PerKeychain.save(key: key, data: data)
    }
    static public func setObjForKey (_ key: String, _ obj: Any) {
        guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: obj, requiringSecureCoding: false) else { return }
            UserDefaults.standard.set(encodedData, forKey: key)
    }
    static public func getObjectForKey(_ key: String) -> AnyObject? {
       
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                if let anyObject = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? AnyObject {
                    return anyObject
                }
            } catch {
				UtilsLogger.log("Couldn't read file.")
            }
            //return NSKeyedUnarchiver.unarchiveObject(with: data)! as AnyObject
        }
        return nil
    }
    static public func getLanguage(_ key: String) -> String{
        let filePath:String = "\(NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0])/language/\(Global.LANG_FILE_NAME)"
        if FileManager.default.fileExists(atPath: filePath) {
            if Global.LANG_JSON.isEmpty {
                let data = try? Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
                Global.LANG_JSON = try! JSONSerialization.jsonObject(with: data!) as! [AnyHashable : Any]
            }
            if (Global.SHOW_LOG) {
                if (Global.LANG_JSON[key] != nil) {
                    //UtilsLog.log("Get text is: \(Global.LANG_JSON[key]!)")
                }
            }
            return Global.LANG_JSON[key] == nil ? "" : Global.LANG_JSON[key] as! String
        }
        return ""
    }
    
    static public func saveLangague (_ _data: NSData) {
        let dirPath:String = "\(NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0])/language"
        let zipPath:String = "\(NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0])/language.zip"
        
		UtilsLogger.log("Language path: \(dirPath)")

        try? FileManager.default.removeItem(atPath: zipPath)
        try? FileManager.default.removeItem(atPath: dirPath)
        do {
            try _data.write(toFile: zipPath, options: .completeFileProtection)
        }
        catch {
			UtilsLogger.log("Error write file")
        }
        
        let zip: Bool = SSZipArchive.unzipFile(atPath: zipPath, toDestination: dirPath)
        if zip {
            try? FileManager.default.removeItem(atPath: zipPath)
        }
    }
    static public func clearCookie() {
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }
        UserDefaults.standard.synchronize()
    }
}
