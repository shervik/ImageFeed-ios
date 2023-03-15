//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 22.02.2023.
//

import Foundation

protocol ProfileServiceProtocol: AnyObject {
    func fetchProfileData(_ token: String, completion: @escaping (Result<ProfileModel, Error>) -> Void)
    var profile: ProfileModel? { get }
}

final class ProfileService: ProfileServiceProtocol {
    static let shared = ProfileService()

    private let networkService = NetworkService()
    private var token: String?
    private var task: URLSessionTask?
    private var currentProfile: ProfileModel?

    private(set) var profile: ProfileModel? {
        get {
            return currentProfile
        }
        set {
            currentProfile = newValue
        }
    }

    private init() { }

    private func profileRequest(_ token: String) -> URLRequest {
        var request = networkService.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            query: nil
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

    func fetchProfileData(_ token: String, completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        assert(Thread.isMainThread)
        if self.token == token { return }
        task?.cancel()

        self.token = token

        task = networkService.data(for: profileRequest(token)) { result in
            self.token = nil
            self.task = nil
            
            switch result {
            case .success(let success):
                guard let data = self.networkService.decodeJson(type: ProfileModel.self, data: success) else { return }
                self.currentProfile = data
                guard let profile = self.currentProfile else { return }
                completion(.success(profile))

            case .failure(let error):
                completion(.failure(error))
            }
        }
        task?.resume()
    }
}
