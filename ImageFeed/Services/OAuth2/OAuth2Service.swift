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
    private var storage = OAuth2TokenStorage()
    private var networkService = NetworkService()

    private(set) var authToken: String {
        get {
            storage.token
        }
        set {
            storage.token = newValue
        }
    }

    func fetchAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        fetchToken(code: code) { result in
            switch result {
            case .success(let body):
                self.authToken = body.accessToken
                completion(.success(self.authToken))
            case .failure(let error):
                completion(.failure(error))
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
            path: "/oauth/token"
            + "?client_id=\(accessKey)"
            + "&&client_secret=\(secretKey)"
            + "&&redirect_uri=\(redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        ) }
}

