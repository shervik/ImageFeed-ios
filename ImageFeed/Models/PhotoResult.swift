//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 17.01.2023.
//

import Foundation

typealias PhotoModel = [PhotoModelElement]

struct PhotoModelElement: Decodable {
    var id: String
    var createdAt, updatedAt: Date
    var width, height: Int
    var color, blurHash: String
    var likes: Int
    var likedByUser: Bool
    var description: String
    var urls: UrlsResult

    struct UrlsResult: Decodable {
        var raw, full, regular, small: String
        var thumb: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width, height, color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case description, urls
    }
}



struct PhotoViewModel {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
