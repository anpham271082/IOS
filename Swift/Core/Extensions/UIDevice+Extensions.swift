import UIKit
extension UIDevice{
    var platformModelString: String? {
        if let key = "hw.machine".cString(using: String.Encoding.utf8) {
            var size: Int = 0
            sysctlbyname(key, nil, &size, nil, 0)
            var machine = [CChar](repeating: 0, count: Int(size))
            sysctlbyname(key, &machine, &size, nil, 0)
            return String(cString: machine)
        }
        return nil
    }
    var platformString: String {
        let platform : String = platformModelString!
        if platform == "iPhone1,1"    { return "iPhone 1G" }
        if platform == "iPhone1,2"    { return "iPhone 3G" }
        if platform == "iPhone2,1"    { return "iPhone 3GS" }
        if platform == "iPhone3,1"    { return "iPhone 4 (GSM)" }
        if platform == "iPhone3,3"    { return "iPhone 4 (CDMA)" }
        if platform == "iPhone4,1"    { return "iPhone 4S" }
        if platform == "iPhone5,1"    { return "iPhone 5 (GSM)" }
        if platform == "iPhone5,2"    { return "iPhone 5 (GSM+CDMA)" }
        if platform == "iPhone5,3"    { return "iPhone 5c (GSM)" }
        if platform == "iPhone5,4"    { return "iPhone 5c (GSM+CDMA)" }
        if platform == "iPhone6,1"    { return "iPhone 5s (GSM)" }
        if platform == "iPhone6,2"    { return "iPhone 5s (GSM+CDMA)" }
        if platform == "iPhone7,1"    { return "iPhone 6 Plus" }
        if platform == "iPhone7,2"    { return "iPhone 6" }
        if platform == "iPhone8,1"    { return "iPhone 6s" }
        if platform == "iPhone8,2"    { return "iPhone 6s Plus" }
        if platform == "iPhone8,4"    { return "iPhone SE" }
        if platform == "iPhone9,1"    { return "iPhone 7 (GSM+CDMA)" }
        if platform == "iPhone9,2"    { return "iPhone 7 Plus (GSM+CDMA)" }
        if platform == "iPhone9,3"    { return "iPhone 7 (GSM)" }
        if platform == "iPhone9,4"    { return "iPhone 7 Plus (GSM)" }
        if platform == "iPhone10,1"   { return "iPhone 8 (GSM+CDMA)" }
        if platform == "iPhone10,2"   { return "iPhone 8 Plus (GSM+CDMA)" }
        if platform == "iPhone10,3"   { return "iPhone X (GSM+CDMA)" }
        if platform == "iPhone10,4"   { return "iPhone 8 (GSM)" }
        if platform == "iPhone10,5"   { return "iPhone 8 Plus (GSM)" }
        if platform == "iPhone10,6"   { return "iPhone X (GSM)" }
        if platform == "iPhone11,2"   { return "iPhone XS" }
        if platform == "iPhone11,6"   { return "iPhone XS Max" }
        if platform == "iPhone11,8"   { return "iPhone XR" }
        if platform == "iPhone12,1"   { return "iPhone 11" }
        if platform == "iPhone12,3"   { return "iPhone 11 Pro" }
        if platform == "iPhone12,5"   { return "iPhone 11 Pro Max" }
        if platform == "iPhone12,8"   { return "iPhone SE (2nd generation)" }
        if platform == "iPhone13,1"   { return "iPhone 12 mini" }
        if platform == "iPhone13,2"   { return "iPhone 12" }
        if platform == "iPhone13,3"   { return "iPhone 12 Pro" }
        if platform == "iPhone13,4"   { return "iPhone 12 Pro Max" }
        if platform == "iPhone14,2"   { return "iPhone 12 Pro" }
        if platform == "iPhone14,3"   { return "iPhone 12 Pro Max" }
        if platform == "iPhone14,4"   { return "iPhone 12 mini" }
        if platform == "iPhone14,5"   { return "iPhone 12" }
        if platform == "iPod1,1"      { return "iPod Touch 1G" }
        if platform == "iPod2,1"      { return "iPod Touch 2G" }
        if platform == "iPod3,1"      { return "iPod Touch 3G" }
        if platform == "iPod4,1"      { return "iPod Touch 4G" }
        if platform == "iPod5,1"      { return "iPod Touch 5G" }
        if platform == "iPad1,1"      { return "iPad" }
        if platform == "iPad2,1"      { return "iPad 2 (WiFi)" }
        if platform == "iPad2,2"      { return "iPad 2 (GSM)" }
        if platform == "iPad2,3"      { return "iPad 2 (CDMA)" }
        if platform == "iPad2,4"      { return "iPad 2 (WiFi)" }
        if platform == "iPad2,5"      { return "iPad Mini (WiFi)" }
        if platform == "iPad2,6"      { return "iPad Mini (GSM)" }
        if platform == "iPad2,7"      { return "iPad Mini (GSM+CDMA)" }
        if platform == "iPad3,1"      { return "iPad 3 (WiFi)" }
        if platform == "iPad3,2"      { return "iPad 3 (GSM+CDMA)" }
        if platform == "iPad3,3"      { return "iPad 3 (GSM)" }
        if platform == "iPad3,4"      { return "iPad 4 (WiFi)" }
        if platform == "iPad3,5"      { return "iPad 4 (GSM)" }
        if platform == "iPad3,6"      { return "iPad 4 (GSM+CDMA)" }
        if platform == "iPad4,1"      { return "iPad Air (WiFi)" }
        if platform == "iPad4,2"      { return "iPad Air (GSM)" }
        if platform == "iPad4,3"      { return "iPad Air (LTE)" }
        if platform == "iPad4,4"      { return "iPad Mini 2 (WiFi)" }
        if platform == "iPad4,5"      { return "iPad Mini 2 (GSM)" }
        if platform == "iPad4,6"      { return "iPad Mini 2 (LTE)" }
        if platform == "iPad4,7"      { return "iPad Mini 3 (WiFi)" }
        if platform == "iPad4,8"      { return "iPad Mini 3 (GSM)" }
        if platform == "iPad4,9"      { return "iPad Mini 3 (LTE)" }
        if platform == "iPad5,3"      { return "iPad Air 2 (WiFi)" }
        if platform == "iPad5,4"      { return "iPad Air 2 (GSM)" }
        if platform == "i386"         { return "Simulator" }
        if platform == "x86_64"       { return "Simulator" }
        return platform
    }
}
struct Device {
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
}
struct ScreenSize{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}
