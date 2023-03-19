//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 11.02.2023.
//

import Foundation

private enum Config {
    static let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let AccessKey = "JsHVnYHPOiTNPk_YfAg4taTjooG_VyEsdw_lW9mslMQ"
    static let SecretKey = "ncDlrDOUmsinmdUfcW36K6tjzJvB9N8tp07D64H1V14"
    static let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let AccessScope = "public+read_user+write_likes"
    static let DefaultBaseURL: URL = URL(string: "https://api.unsplash.com/")!
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String

    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Config.AccessKey,
                                 secretKey: Config.SecretKey,
                                 redirectURI: Config.RedirectURI,
                                 accessScope: Config.AccessScope,
                                 authURLString: Config.UnsplashAuthorizeURLString,
                                 defaultBaseURL: Config.DefaultBaseURL)
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
