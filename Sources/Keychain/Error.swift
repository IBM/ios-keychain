//
//  NSErrorHelper.swift
//  
//
//  Created by Daniel Mandea on 05/04/2020.
//

import Foundation

extension NSError {
    static func error(with text: String) -> NSError {
        return NSError(domain: "Keychain", code: 3, userInfo: [NSLocalizedDescriptionKey: text])
    }
}
