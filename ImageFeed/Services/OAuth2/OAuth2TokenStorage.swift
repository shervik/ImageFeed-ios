//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 18.02.2023.
//

import Foundation

final class OAuth2TokenStorage {
    var token: String {
        get {
            UserDefaults.standard.string(forKey: "token") ?? String()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "token")
        }
    }
}
