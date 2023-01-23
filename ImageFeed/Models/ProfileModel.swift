//
//  ProfileModel.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 17.01.2023.
//

import UIKit

struct ProfileModel {
    var avatar: UIImage
    var name: String
    var surname: String
    var nickname: String
    var description: String
    
    var fullName: String {
        return "\(name) \(surname)"
    }
}
