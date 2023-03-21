//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 17.03.2023.
//

import Foundation

protocol AuthHelperProtocol {
    var authRequest: URLRequest? { get }
    func code(from url: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    private let configuration: AuthConfiguration

    var authRequest: URLRequest? {
        guard let url = urlComponents else { return nil }
        return URLRequest(url: url)
    }

    private var urlComponents: URL? {
        var urlComponents = URLComponents(string: configuration.authURLString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        return urlComponents?.url
    }

    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }

    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
