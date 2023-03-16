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
    
    private let networkService = NetworkService()
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

    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if self.username == username { return }
        task?.cancel()

        self.username = username

        task = networkService.data(for: profileImageRequest(username: username)) { [weak self ]result in
            guard let self = self else { return }
            self.username = nil

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
            }
        }
        task?.resume()
    }

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
}
