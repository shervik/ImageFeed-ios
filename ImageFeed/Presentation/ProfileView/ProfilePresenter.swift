//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 23.01.2023.
//

import UIKit

protocol ProfileProtocol: AnyObject {
    var profileModel: ProfileModel { get }
}

final class ProfilePresenter: ProfileProtocol {
    var profileModel: ProfileModel {
        ProfileModel(avatar: UIImage(named: "avatar") ?? UIImage(),
                     name: "Екатерина",
                     surname: "Новикова",
                     nickname: "@ekaterina_nov",
                     description: "Hello, world!")
    }
    

}
