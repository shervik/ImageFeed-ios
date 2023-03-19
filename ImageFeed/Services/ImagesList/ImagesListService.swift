//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 11.03.2023.
//

import Foundation

protocol ImagesListServiceProtocol: AnyObject {
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
    var photos: PhotoModel { get }
}

final class ImagesListService: ImagesListServiceProtocol {
    static let shared = ImagesListService()

    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let networkService = NetworkService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")

    private(set) var photos: PhotoModel = [] {
        didSet {
            NotificationCenter.default
                .post(
                    name: ImagesListService.didChangeNotification,
                    object: self)
        }
    }

    private init() { }

    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if task != nil { return }
        task?.cancel()

        let nextPage = lastLoadedPage == nil ? 1 : (lastLoadedPage ?? 0) + 1

        task = networkService.data(for: photosRequest(page: nextPage)) { [weak self] result in
            guard let self = self else { return }

            self.task = nil

            switch result {
            case .success(let success):
                guard let data = self.networkService.decodeJson(type: PhotoModel.self, data: success) else { return }
                self.lastLoadedPage = nextPage
                self.photos.append(contentsOf: data)

            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
        task?.resume()
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil { return }
        task?.cancel()

        let request = isLike ? postLikesRequest(photo: photoId) : deleteLikesRequest(photo: photoId)

        task = networkService.data(for: request) { [weak self] result in
            guard let self = self else { return }
            self.task = nil

            switch result {
            case .success(let success):
                guard let data = self.networkService.decodeJson(type: LikesModel.self, data: success) else { return }

                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let newPhoto = data.photo
                    self.photos[index] = newPhoto
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task?.resume()
    }

    private func postLikesRequest(photo id: String) -> URLRequest {
        var request = networkService.makeHTTPRequest(
            path: "/photos/\(id)/like",
            httpMethod: "POST",
            query: nil
        )

        if let token = OAuth2TokenStorage().token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    private func deleteLikesRequest(photo id: String) -> URLRequest {
        var request = networkService.makeHTTPRequest(
            path: "/photos/\(id)/like",
            httpMethod: "DELETE",
            query: nil
        )

        if let token = OAuth2TokenStorage().token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
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
