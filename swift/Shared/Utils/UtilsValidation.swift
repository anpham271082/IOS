//
//  UtilsValidation.swift
//  application_ios
//
//  Created by An Pham Ngoc on 9/13/24.
//

import Foundation
final class UtilsValidation:NSObject{
    static let sharedInstance = UtilsValidation()
    override fileprivate init() {}
    func isValidEmail(email:String?) -> Bool {
        guard email != nil else { return false }
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    func isGoodPassWord(pass:String?) -> Bool {
        let password = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return password.evaluate(with: pass)
    }
    func isStrongPassWord(pass:String?) -> Bool {
        let password = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{10,}")
        let ret = password.evaluate(with: pass)
        
        if (ret) {
            let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: NSRegularExpression.Options())
            if regex.firstMatch(in: pass!, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, pass!.count)) != nil {
                // print("have special characters")
            }
            else {
                // print("dont have special s")
                return false
            }
        }
        return ret
    }

    func passwordLevel(strPass: String) -> String {
        if strPass.count < Global.MIN_PASS_LEN {
            return "1;1"
        }
        if (strPass.count >= Global.MIN_PASS_LEN && strPass.count < Global.GOOD_PASS_LEN) {
            return "1;2"
        }
        var curVar = "2"
        if (self.isStrongPassWord(pass: strPass)) {
            curVar = "4"
        }
        else if (self.isGoodPassWord(pass: strPass)) {
            curVar = "3"
        }
        return "1;\(curVar)"
    }
}
