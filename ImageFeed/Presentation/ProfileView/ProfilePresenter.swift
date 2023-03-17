//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 23.01.2023.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    func presentProfile()
    func presentAlert()
    func addObserver()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    private var profileService = ProfileService.shared
    private var profileImageService = ProfileImageService.shared
    private var tokenStorage: OAuth2TokenStorage
    private var alertPresenter: AlertPresenterProtocol?
    private weak var viewController: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?

    init(viewController: ProfileViewControllerProtocol, alert: AlertPresenterProtocol) {
        self.alertPresenter = alert
        self.viewController = viewController
        self.tokenStorage = OAuth2TokenStorage()
    }

    func presentAlert() {
        let alertExit = AlertModel(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            primaryButtonText: "Да",
            primaryCompletion: { [weak self] in
                guard let self = self else { return }

                self.tokenStorage.token = nil
                WebViewViewController.clean()
                self.viewController?.didExitFromAccount()
            },
            secondButtonText: "Нет",
            secondCompletion:  { return })

        alertPresenter?.showAlert(alert: alertExit)
    }

    func presentProfile() {
        guard let profileModel = profileService.profile else { return }
        let viewModel = convertToViewModel(model: profileModel)
        viewController?.showProfile(viewModel)
    }

    func addObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    self?.updateAvatar()
                }
        updateAvatar()
    }

    private func updateAvatar() {
        if let profileImageURL = profileImageService.avatarURL,
           let url = URL(string: profileImageURL) {
            viewController?.showAvatar(urlImage: url)
        }
    }

    private func convertToViewModel(model: ProfileModel) -> ProfileViewModel {
        return ProfileViewModel(username: model.username,
                                fullName: "\(model.firstName) \(model.lastName)",
                                loginName: "@\(model.username)",
                                bio: model.bio ?? "Hello world!")
    }
}
