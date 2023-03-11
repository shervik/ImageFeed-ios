//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 18.02.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let keychain = KeychainWrapper.standard

    var token: String? {
        get {
            keychain.string(forKey: "token")
        }
        set {
            if let token = newValue {
                keychain.set(token, forKey: "token")
            } else {
                keychain.removeObject(forKey: "token")
            }
        }
    }
}
