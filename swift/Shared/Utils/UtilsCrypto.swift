//
//  UtilsCrypto.swift
//  application_ios
//
//  Created by An Pham Ngoc on 9/13/24.
//

import CryptoSwift
import CommonCrypto
extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    var md5: String {
        return HMAC.hash(inp: self, algo: HMACAlgo.MD5)
    }
    
    var sha1: String {
        return HMAC.hash(inp: self, algo: HMACAlgo.SHA1)
    }
    
    var sha224: String {
        return HMAC.hash(inp: self, algo: HMACAlgo.SHA224)
    }
    
    var sha256: String {
        return HMAC.hash(inp: self, algo: HMACAlgo.SHA256)
    }
    
    var sha384: String {
        return HMAC.hash(inp: self, algo: HMACAlgo.SHA384)
    }
    
    var sha512: String {
        return HMAC.hash(inp: self, algo: HMACAlgo.SHA512)
    }
    
    func aesEncrypt(key:String, iv:String, options:Int = kCCOptionPKCS7Padding) -> String? {
        if let keyData = key.data(using: String.Encoding.utf8),
            let data = self.data(using: String.Encoding.utf8),
            let cryptData    = NSMutableData(length: Int((data.count)) + kCCBlockSizeAES128) {
            
            let keyLength              = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCEncrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)
            
            var numBytesEncrypted :size_t = 0
            
            let base64cryptStringOut = keyData.withUnsafeBytes {(keyBytes: UnsafePointer<CChar>)->String? in
                return data.withUnsafeBytes {(dataBytes: UnsafePointer<CChar>)->String? in
                    
                    let cryptStatus = CCCrypt(operation,
                                              algoritm,
                                              options,
                                              keyBytes, keyLength,
                                              iv,
                                              dataBytes, data.count,
                                              cryptData.mutableBytes, cryptData.length,
                                              &numBytesEncrypted)
                    
                    if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                        cryptData.length = Int(numBytesEncrypted)
                        let base64cryptString = cryptData.base64EncodedString(options: .lineLength64Characters)
                        return base64cryptString
                    }
                    else {
                        return nil
                    }
                }
            }
            return base64cryptStringOut
        }
        return nil
    }
    
    enum AESError: Error {
        case KeyError((String, Int))
        case IVError((String, Int))
        case CryptorError((String, Int))
    }
    
    func aesEncryptAES256(key: String, iv: String) throws -> String {
        var result = ""
        do {
            let key: [UInt8] = Array(key.utf8) as [UInt8]
            let iv8: [UInt8] = Array(iv.utf8) as [UInt8]
            let aes = try! AES(key: key, blockMode: CBC(iv: iv8), padding: .pkcs5) // AES128 .ECB pkcs7
            let encrypted = try aes.encrypt(Array(self.utf8))
            
            result = encrypted.toBase64()
            //if (Global.SHOW_LOG) {
                //print("AES Encryption Result: \(result)")
            //}
        } catch {
            print("Error: \(error)")
        }
        return result
    }
    
    func aesDecryptAES256(key: String, iv: String) throws -> String {
        var result = ""
        do {
            let encrypted = self
            let key: [UInt8] = Array(key.utf8) as [UInt8]
            let iv8: [UInt8] = Array(iv.utf8) as [UInt8]
            let aes = try! AES(key: key, blockMode: CBC(iv: iv8), padding: .pkcs5) // AES128 .ECB pkcs7
            let decrypted = try aes.decrypt(Array(base64: encrypted))
            result = String(data: Data(decrypted), encoding: .utf8) ?? ""
            //if (Global.SHOW_LOG) {
            //    print("AES Decryption Result: \(result)")
            //}
            
        } catch {
            print("Error: \(error)")
        }
        return result
    }
    
    // The iv is prefixed to the encrypted data
    func aesCBCDecrypt(data:Data, keyData:Data) throws -> Data? {
        let keyLength = keyData.count
        let validKeyLengths = [kCCKeySizeAES128, kCCKeySizeAES192, kCCKeySizeAES256]
        if (validKeyLengths.contains(keyLength) == false) {
            throw AESError.KeyError(("Invalid key length", keyLength))
        }
        
        let ivSize = kCCBlockSizeAES128;
        let clearLength = size_t(data.count - ivSize)
        var clearData = Data(count:clearLength)
        
        var numBytesDecrypted :size_t = 0
        let options   = CCOptions(kCCOptionPKCS7Padding)
        
        let cryptStatus = clearData.withUnsafeMutableBytes {cryptBytes in
            data.withUnsafeBytes {dataBytes in
                keyData.withUnsafeBytes {keyBytes in
                    CCCrypt(CCOperation(kCCDecrypt),
                            CCAlgorithm(kCCAlgorithmAES128),
                            options,
                            keyBytes, keyLength,
                            dataBytes,
                            dataBytes+kCCBlockSizeAES128, clearLength,
                            cryptBytes, clearLength,
                            &numBytesDecrypted)
                }
            }
        }
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            clearData.count = numBytesDecrypted
        }
        else {
            throw AESError.CryptorError(("Decryption failed", Int(cryptStatus)))
        }
        
        return clearData;
    }
    
    func aesDecrypt(key:String, iv:String, options:Int = kCCOptionPKCS7Padding) -> String? {
        if let keyData = key.data(using: String.Encoding.utf8),
            let data = NSData(base64Encoded: self, options: .ignoreUnknownCharacters),
            let cryptData    = NSMutableData(length: Int((data.length)) + kCCBlockSizeAES128) {
            
            let keyLength              = size_t(kCCKeySizeAES128)
            let operation: CCOperation = UInt32(kCCDecrypt)
            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
            let options:   CCOptions   = UInt32(options)
            
            var numBytesEncrypted :size_t = 0
            
            let unencryptedMessageOut = keyData.withUnsafeBytes {(keyBytes: UnsafePointer<CChar>)->String? in
                let cryptStatus = CCCrypt(operation,
                                          algoritm,
                                          options,
                                          keyBytes, keyLength,
                                          iv,
                                          data.bytes, data.length,
                                          cryptData.mutableBytes, cryptData.length,
                                          &numBytesEncrypted)
                
                if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                    cryptData.length = Int(numBytesEncrypted)
                    let unencryptedMessage = String(data: cryptData as Data, encoding:String.Encoding.utf8)
                    return unencryptedMessage
                }
                else {
                    return nil
                }
            }
            return unencryptedMessageOut
        }
        return nil
    }
}

public struct HMAC {
    
    static func hash(inp: String, algo: HMACAlgo) -> String {
        if let stringData = inp.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            return hexStringFromData(input: digest(input: stringData as NSData, algo: algo))
        }
        return ""
    }
    
    private static func digest(input : NSData, algo: HMACAlgo) -> NSData {
        let digestLength = algo.digestLength()
        var hash = [UInt8](repeating: 0, count: digestLength)
        switch algo {
        case .MD5:
            CC_MD5(input.bytes, UInt32(input.length), &hash)
            break
        case .SHA1:
            CC_SHA1(input.bytes, UInt32(input.length), &hash)
            break
        case .SHA224:
            CC_SHA224(input.bytes, UInt32(input.length), &hash)
            break
        case .SHA256:
            CC_SHA256(input.bytes, UInt32(input.length), &hash)
            break
        case .SHA384:
            CC_SHA384(input.bytes, UInt32(input.length), &hash)
            break
        case .SHA512:
            CC_SHA512(input.bytes, UInt32(input.length), &hash)
            break
        }
        return NSData(bytes: hash, length: digestLength)
    }
    
    private static func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
    
}

enum HMACAlgo {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

