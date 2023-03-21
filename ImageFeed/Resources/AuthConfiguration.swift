//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 11.02.2023.
//

import Foundation

private enum Config {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let accessKey = "JsHVnYHPOiTNPk_YfAg4taTjooG_VyEsdw_lW9mslMQ"
    static let secretKey = "ncDlrDOUmsinmdUfcW36K6tjzJvB9N8tp07D64H1V14"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL: URL = URL(string: "https://api.unsplash.com/")!
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String

    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Config.accessKey,
                                 secretKey: Config.secretKey,
                                 redirectURI: Config.redirectURI,
                                 accessScope: Config.accessScope,
                                 authURLString: Config.unsplashAuthorizeURLString,
                                 defaultBaseURL: Config.defaultBaseURL)
    }

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
