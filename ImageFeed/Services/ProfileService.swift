//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 22.02.2023.
//

import Foundation

protocol ProfileManager {
    func fetchProfileData(completion: @escaping (Result<ProfileModel, Error>) -> Void)
}

final class ProfileService: ProfileManager {
    private var networkService = NetworkService()

    private func profileRequest() -> URLRequest {
        var request = networkService.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            query: nil
        )
        
        if let token = OAuth2TokenStorage().token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    func fetchProfileData(completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        networkService.data(for: profileRequest()) { result in
            switch result {
            case .success(let data):
                guard let data = self.networkService.decodeJson(type: ProfileModel.self, data: data) else { return }
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
