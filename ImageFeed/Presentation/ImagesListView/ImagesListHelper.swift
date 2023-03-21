//
//  ImagesListHelper.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 19.03.2023.
//

import Foundation

protocol ImagesListHelperProtocol {
    var photoModel: PhotoModel? { get }
    func loadNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}

final class ImagesListHelper: ImagesListHelperProtocol {
    private var imagesService = ImagesListService.shared

    var photoModel: PhotoModel? {
        imagesService.photos
    }

    func loadNextPage() {
        imagesService.fetchPhotosNextPage()
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        imagesService.changeLike(photoId: photoId, isLike: isLike) { _ in
            completion(.success(()))
        }
    }
}
