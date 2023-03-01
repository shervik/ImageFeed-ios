//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 17.02.2023.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken, tokenType, scope: String
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}
