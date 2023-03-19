//
//  ImagesListHelper.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 19.03.2023.
//

import Foundation

protocol ImagesListHelperProtocol {
    func loadNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
    func returnPhotoModel() -> PhotoModel?
}

final class ImagesListHelper: ImagesListHelperProtocol {
    private var imagesService = ImagesListService.shared

    func loadNextPage() {
        imagesService.fetchPhotosNextPage()
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        imagesService.changeLike(photoId: photoId, isLike: isLike) { _ in
            completion(.success(()))
        }
    }

    func returnPhotoModel() -> PhotoModel? {
        return imagesService.photos
    }
}
