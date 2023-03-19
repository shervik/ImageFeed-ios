//
//  ImagesListHeplerSpy.swift
//  ImageFeedTests
//
//  Created by Виктория Щербакова on 20.03.2023.
//

import Foundation
@testable import ImageFeed

final class ImagesListHeplerSpy: ImagesListHelperProtocol {
    var nextPageIsLoad = false
    var likeIsChanged = false

    func loadNextPage() {
        nextPageIsLoad = true
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        likeIsChanged = true
    }

    func returnPhotoModel() -> PhotoModel? {
        return nil
    }


}
