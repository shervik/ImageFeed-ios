//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 11.03.2023.
//

import Foundation

protocol ImagesListServiceProtocol: AnyObject {
    func fetchPhotosNextPage()
    var photos: PhotoModel { get }
}

final class ImagesListService: ImagesListServiceProtocol {
    static let shared = ImagesListService()

    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private (set) var photos: PhotoModel = []
    private var networkService = NetworkService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")

    private init() { }

    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        task?.cancel()

        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1

        networkService.data(for: photosRequest(page: nextPage)) { result in
            switch result {
            case .success(let success):
                guard let data = self.networkService.decodeJson(type: PhotoModel.self, data: success) else { return }
                self.photos.append(contentsOf: data)

                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["Photo": data])

            case .failure(_):
                return
            }
        }
    }

    private func photosRequest(page number: Int) -> URLRequest {
        var request = networkService.makeHTTPRequest(
            path: "/photos",
            httpMethod: "GET",
            query: [URLQueryItem(name: "page", value: String(number))]
        )
        if let token = OAuth2TokenStorage().token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
}
