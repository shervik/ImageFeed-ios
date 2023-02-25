//
//  ProfileModel.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 17.01.2023.
//

import Foundation

struct ProfileModel: Decodable {
    var username, firstName, lastName: String
    var bio: String?

    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }

    var fullName: String {
        "\(firstName) \(lastName)"
    }
}
