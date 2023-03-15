//
//  PhotoViewModel.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 13.03.2023.
//

import Foundation

typealias PhotosViewModel = [PhotoViewModel]

struct PhotoViewModel {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
