//
//  KeyChain.swift
//  Munecting_iOS
//
//  Created by seonwoo on 2023/08/21.
//

import Foundation
//import Security

class KeyChain{
    
    func create(key: String, token: String) {
        
        UserDefaults.standard.set(token, forKey: key)
        
//        let query: NSDictionary = [
//            kSecClass: kSecClassGenericPassword,
//            kSecAttrAccount: key,   // 저장할 Account
//            kSecValueData: token.data(using: .utf8, allowLossyConversion: false) as Any   // 저장할 Token
//        ]
//
//        SecItemDelete(query)    // Keychain은 Key값에 중복이 생기면, 저장할 수 없기 때문에 먼저 Delete해줌
//
//        let status = SecItemAdd(query, nil)
//        assert(status == noErr, "failed to save Token")
    }
    
    // Read
    func read(key: String) -> String? {
        let token:String? = UserDefaults.standard.string(forKey: key)
        return token
        
//        let query: NSDictionary = [
//            kSecClass: kSecClassGenericPassword,
//            kSecAttrAccount: key,
//            kSecReturnData: kCFBooleanTrue as Any,  // CFData 타입으로 불러오라는 의미
//            kSecMatchLimit: kSecMatchLimitOne       // 중복되는 경우, 하나의 값만 불러오라는 의미
//        ]
//
//        var dataTypeRef: AnyObject?
//        let status = SecItemCopyMatching(query, &dataTypeRef)
//
//        if status == errSecSuccess {
//            if let retrievedData: Data = dataTypeRef as? Data {
//                let value = String(data: retrievedData, encoding: String.Encoding.utf8)
//                return value
//            } else { return nil }
//        } else {
//            print("failed to loading, status code = \(status)")
//            return nil
//        }
    }
    
    // Delete
    func delete(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
//        let query: NSDictionary = [
//            kSecClass: kSecClassGenericPassword,
//            kSecAttrAccount: key
//        ]
//        let status = SecItemDelete(query)
//        assert(status == noErr, "failed to delete the value, status code = \(status)")
    }

    
}
