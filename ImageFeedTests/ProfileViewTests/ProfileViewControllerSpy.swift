//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Виктория Щербакова on 17.03.2023.
//

import Foundation
import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    func configure(_ presenter: ProfilePresenterProtocol) {
        presenter.view = self
    }

    func showProfile(_ model: ProfileViewModel?) {

    }

    func showAvatar(urlImage: URL) {

    }

    func didExitFromAccount() {

    }
}
