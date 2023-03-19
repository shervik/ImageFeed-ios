//
//  PhotoMock.swift
//  ImageFeedTests
//
//  Created by Виктория Щербакова on 19.03.2023.
//

import Foundation
@testable import ImageFeed

struct PhotoMock {
    static let photos: PhotosViewModel = [
        PhotoViewModel(
            id: "1",
            size: CGSize(width: 100, height: 100),
            createdAt: Date(),
            welcomeDescription: "TestDescription1",
            thumbImageURL: "thumbImageURL1",
            largeImageURL: "largeImageURL1",
            isLiked: true),
        PhotoViewModel(
            id: "2",
            size: CGSize(width: 200, height: 200),
            createdAt: Date(),
            welcomeDescription: "TestDescription2",
            thumbImageURL: "thumbImageURL2",
            largeImageURL: "largeImageURL2",
            isLiked: false)
    ]
}
