//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 17.02.2023.
//

import Foundation

protocol AuthRouting: AnyObject {
    func fetchAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void)
}

final class OAuth2Service: AuthRouting {
    static let shared = OAuth2Service()

    private let authConfiguration = AuthConfiguration.standard
    private var storage = OAuth2TokenStorage()
    private let networkService = NetworkService()
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

        fetchToken(code: code) { [weak self] result in
            guard let self = self else { return }
            self.code = nil

            switch result {
            case .success(let body):
                self.authToken = body.accessToken
                completion(.success(body.accessToken))

            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        self.code = code
    }

    private func fetchToken(code: String, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) {
        if task != nil { return }
        task?.cancel()

        task = networkService.data(for: authTokenRequest(code: code)) { [weak self] result in
            guard let self = self else { return }
            self.task = nil

            switch result {
            case .success(let data):
                guard let data = self.networkService.decodeJson(type: OAuthTokenResponseBody.self, data: data) else { return }
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task?.resume()
    }

    private func authTokenRequest(code: String) -> URLRequest {
        networkService.makeHTTPRequest(
            baseURL: URL(string: "https://unsplash.com")!,
            path: "/oauth/token",
            httpMethod: "POST",
            query: [URLQueryItem(name: "client_id", value: authConfiguration.accessKey),
                    URLQueryItem(name: "client_secret", value: authConfiguration.secretKey),
                    URLQueryItem(name: "redirect_uri", value: authConfiguration.redirectURI),
                    URLQueryItem(name: "code", value: code),
                    URLQueryItem(name: "grant_type", value: "authorization_code")]
        )
    }
}

