//
//  PhotoViewModel.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 13.03.2023.
//

import Foundation

public typealias PhotosViewModel = [PhotoViewModel]

public struct PhotoViewModel {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
