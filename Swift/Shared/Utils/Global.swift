//
//  Global.swift
//  application_ios
//
//  Created by An Pham Ngoc on 9/13/24.
//

import Foundation
struct Global {
    static let SHOW_LOG = true
    static let MAX_RETRY = 10
    static let USE_BASIC_AUTH = true
    static let EN_KEY = "fFrFSYme4zcS9fQ648p2DmhNFkk3jVPC"
    static let EN_IV = "SfGkEJFMaFJUf3xN"
    
    static let RETURN_CODE_BAD_REQ = 400
    static let RETURN_CODE_BAD_FOR = 403
    static let RETURN_CODE_NOT_ACCEPT = 206
    static let RETURN_CODE_SUCCESS = 200
    static let RETURN_CODE_LOCKED = 423
    static let RETURN_CODE_EXPIRE_TOKEN = 401
    
    static let API_CODE_SUCCESS = 0
    static let API_CODE_EXPIRE = 1
    static let API_CODE_BAD_REQ = 2
    static let API_CODE_ERROR = 3
    static let API_CODE_NO_NETWORK = 4
    
    static let NETWORK_METHOD_GET = 0
    static let NETWORK_METHOD_POST = 1
    static let NETWORK_METHOD_PUT = 2
    static let NETWORK_METHOD_DELETE = 3
    
    static let APP_ID = "id1414265780"
    
    static let LANG_FILE_NAME = "language.json"
    static var LANG_JSON = [AnyHashable:Any]()
    
    static let PHONE_MIN_LEN = 8
    static let PHONE_MAX_LEN = 13
    
    static let MIN_PHOTO_ALLOW = 2

    static let MIN_PASS_LEN = 6
    static let GOOD_PASS_LEN = 8
    static let STRONG_PASS_PEN = 10
    
    static let BASE_URL = ""
    static let AUTH_USERNAME = ""
    static let AUTH_PASS = ""
    
    static let DATABASE_SQLITE = "PNA.db"
    static let DATABASE_SQLITE_PASS = "aimabiet123"
    
    static let ITUNES_URL = Bundle.main.infoDictionary!["ITUNES_URL"] as! String
    static let LANGUAGE_PREFIX = "en:"
}
