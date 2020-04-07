//
//  Keychain.swift
//  
//
//  Created by Daniel Mandea on 05/04/2020.
//

import Foundation
import Security

public class Keychain {
    public struct Dependencies {
        public init() {}
        var itemCopyMatching: (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus = SecItemCopyMatching
        var itemUpdate: (CFDictionary, CFDictionary) -> OSStatus = SecItemUpdate
        var itemAdd: (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus = SecItemAdd
        var itemDelete: (CFDictionary) -> OSStatus = SecItemDelete
    }
    
    public static func store(_ data: Data, for key: String, dependencies: Dependencies = Dependencies()) throws {
        let query = baseQuery(withKey: key)
        let status: OSStatus
        if dependencies.itemCopyMatching(query, nil) == noErr {
            status = dependencies.itemUpdate(query, NSDictionary(dictionary: [kSecValueData: data]))
        } else {
            query.setValue(data, forKey: kSecValueData as String)
            status = dependencies.itemAdd(query, nil)
        }
        guard status == noErr else {  throw NSError.error(with: "Failed to store key") }
    }
    
    public static func delete(for key: String, dependencies: Dependencies = Dependencies()) throws {
        let query = baseQuery(withKey: key)
        let status: OSStatus = dependencies.itemDelete(query)
        guard status == noErr else { throw NSError.error(with: "Failed to delete key") }
    }
    
    public static func fetch(for key: String, dependencies: Dependencies = Dependencies()) throws -> Data? {
        let query = baseQuery(withKey: key)
        query.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
        query.setValue(kCFBooleanTrue, forKey: kSecReturnAttributes as String)
        var result: CFTypeRef?
        let status = dependencies.itemCopyMatching(query, &result)
        guard let resultsDict = result as? NSDictionary,
            let value = resultsDict.value(forKey: kSecValueData as String) as? Data, status == noErr else {
                throw NSError.error(with: "Failed to fetch key")
        }
        return value
    }
    
    /// This method is responsible to create some base query for storing Data securely in Keychain.
    /// - Parameter key: The key that will be used for storing actual data in Keychain
    private static func baseQuery(withKey key: String) -> NSMutableDictionary {
        NSMutableDictionary(dictionary: [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        ])
    }
}
