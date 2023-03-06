//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 05.03.2023.
//

import Foundation

protocol ProfileImageServiceProtocol: AnyObject {
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void)
    var avatarURL: String? { get }
}

final class ProfileImageService: ProfileImageServiceProtocol {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private var networkService = NetworkService()
    private var username: String?
    private var task: URLSessionTask?
    private var currentAvatar: String?

    private(set) var avatarURL: String? {
        get {
            return currentAvatar
        }
        set {
            currentAvatar = newValue
        }
    }

    private init() { }

    private func profileImageRequest(username: String) -> URLRequest {
        var request = networkService.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "GET",
            query: nil
        )
        if let token = OAuth2TokenStorage().token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if self.username == username { return }
        task?.cancel()

        self.username = username

        networkService.data(for: profileImageRequest(username: username)) { result in
            switch result {
            case .success(let success):
                guard let data = self.networkService.decodeJson(type: ProfileImage.self, data: success) else { return }
                let image = data.profileImage.large
                self.currentAvatar = image
                completion(.success(image))

                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": image])

            case .failure(let error):
                completion(.failure(error))
                self.username = nil
            }
        }
    }
}
