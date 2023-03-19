//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 17.01.2023.
//

import Foundation

public struct ProfileModel: Decodable {
    var username, firstName, lastName: String
    var bio: String?

    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct ProfileImage: Decodable {
    var profileImage: ProfileImageScale

    struct ProfileImageScale: Decodable {
        var small, medium, large: String
    }

    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
