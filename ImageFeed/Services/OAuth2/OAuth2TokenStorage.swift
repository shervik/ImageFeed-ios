//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 18.02.2023.
//

import Foundation

final class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard

    var token: String? {
        get {
            userDefaults.string(forKey: "token")
        }
        set {
            userDefaults.set(newValue, forKey: "token")
        }
    }
}
