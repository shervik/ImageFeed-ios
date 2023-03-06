//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 23.01.2023.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    func presentProfile(_ profile: ProfileViewModel?)
    func presentAlert()
    func presentAvatar()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    private var alertPresenter: AlertPresenterProtocol?
    private var profileImageService = ProfileImageService.shared
    private weak var viewController: ProfileViewControllerProtocol?

    init(viewController: ProfileViewControllerProtocol, alert: AlertPresenterProtocol) {
        self.alertPresenter = alert
        self.viewController = viewController
    }

    // MARK: - ProfileDelegate

    func presentAlert() {
        let alertExit = AlertModel(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            primaryButtonText: "Да",
            primaryCompletion: {
                OAuth2TokenStorage().removeObject(forKey: "token")
                self.viewController?.didExitFromAccount()
            },
            secondButtonText: "Нет",
            secondCompletion:  { return })

        alertPresenter?.showAlert(alert: alertExit)
    }

    func presentProfile(_ profile: ProfileViewModel?) {
        guard let profile = profile else { return }
        viewController?.showProfile(profile)
    }

    func presentAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            viewController?.showAvatar(urlImage: nil)
            return
        }
        viewController?.showAvatar(urlImage: url)
    }
}
