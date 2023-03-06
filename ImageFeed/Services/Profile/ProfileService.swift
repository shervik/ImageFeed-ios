//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 22.02.2023.
//

import Foundation

protocol ProfileServiceProtocol: AnyObject {
    func fetchProfileData(_ token: String, completion: @escaping (Result<ProfileViewModel, Error>) -> Void)
    var profile: ProfileViewModel? { get }
}

final class ProfileService: ProfileServiceProtocol {
    static let shared = ProfileService()

    private var networkService = NetworkService()
    private var token: String?
    private var task: URLSessionTask?
    private var currentProfile: ProfileViewModel?

    private(set) var profile: ProfileViewModel? {
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

    func fetchProfileData(_ token: String, completion: @escaping (Result<ProfileViewModel, Error>) -> Void) {
        assert(Thread.isMainThread)
        if self.token == token { return }
        task?.cancel()

        self.token = token

        networkService.data(for: profileRequest(token)) { result in
            switch result {
            case .success(let success):
                guard let data = self.networkService.decodeJson(type: ProfileModel.self, data: success) else { return }
                let profile = ProfileViewModel(model: data)
                self.currentProfile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
                self.token = nil
            }
        }
    }
}
