//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 17.02.2023.
//

import Foundation

protocol AuthRouting {
    func fetchAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void)
}

final class OAuth2Service: AuthRouting {
    static let shared = OAuth2Service()
    
    private var storage = OAuth2TokenStorage()
    private var networkService = NetworkService()
    private var code: String?
    private var task: URLSessionTask?

    private(set) var authToken: String? {
        get {
            storage.token
        }
        set {
            storage.token = newValue
        }
    }

    private init() { }

    func fetchAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if self.code == code { return }
        task?.cancel()

        self.code = code

        fetchToken(code: code) { result in
            switch result {
            case .success(let body):
                self.authToken = body.accessToken
                completion(.success(body.accessToken))
                self.code = nil
            case .failure(let error):
                completion(.failure(error))
                self.code = nil
            }
        }
    }

    private func fetchToken(code: String, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) {
        networkService.data(for: authTokenRequest(code: code)) { result in
            switch result {
            case .success(let data):
                guard let data = self.networkService.decodeJson(type: OAuthTokenResponseBody.self, data: data) else { return }
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func authTokenRequest(code: String) -> URLRequest {
        networkService.makeHTTPRequest(
            baseURL: URL(string: "https://unsplash.com")!,
            path: "/oauth/token",
            httpMethod: "POST",
            query: [URLQueryItem(name: "client_id", value: accessKey),
                    URLQueryItem(name: "client_secret", value: secretKey),
                    URLQueryItem(name: "redirect_uri", value: redirectURI),
                    URLQueryItem(name: "code", value: code),
                    URLQueryItem(name: "grant_type", value: "authorization_code")]
        )
    }
}

