//
//  AppSettings.swift
//  application_ios
//
//  Created by An Pham Ngoc on 9/14/24.
//

import Foundation
import SSZipArchive
struct UtilsLogger{
    static public func log(_ message: Any) {
        if Global.SHOW_LOG {
            print("\(message)")
        }
    }
    static public func log(_ object: Any, _ message: Any) {
        if Global.SHOW_LOG {
            print("\(object) \(message)")
        }
    }
    static public func log(_ object: Any, _ strCaption: String, _ message: Any) {
        if Global.SHOW_LOG {
            print("\(String(describing: type(of: object))) \(strCaption) \(message)")
        }
    }
}
