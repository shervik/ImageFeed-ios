//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 23.01.2023.
//

import Foundation

public protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func presentProfile()
    func presentAlert()
    func addObserver()
    func convertToViewModel(model: ProfileModel) -> ProfileViewModel
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private var profileService = ProfileService.shared
    private var profileImageService = ProfileImageService.shared
    private var tokenStorage: OAuth2TokenStorage?
    private var alertPresenter: AlertPresenterProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?

    init(alert: AlertPresenterProtocol) {
        self.alertPresenter = alert
        self.tokenStorage = OAuth2TokenStorage()
    }

    func presentAlert() {
        let alertExit = AlertModel(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            primaryButtonText: "Да",
            primaryCompletion: { [weak self] in
                guard let self = self else { return }

                WebViewViewController.clean()
                self.tokenStorage?.token = nil
                self.view?.didExitFromAccount()
            },
            secondButtonText: "Нет",
            secondCompletion:  { return })

        alertPresenter?.showAlert(alert: alertExit)
    }

    func presentProfile() {
        guard let profileModel = profileService.profile else { return }
        let viewModel = convertToViewModel(model: profileModel)
        view?.showProfile(viewModel)
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
            view?.showAvatar(urlImage: url)
        }
    }

    func convertToViewModel(model: ProfileModel) -> ProfileViewModel {
        return ProfileViewModel(username: model.username,
                                fullName: "\(model.firstName) \(model.lastName)",
                                loginName: "@\(model.username)",
                                bio: model.bio ?? "Hello world!")
    }
}
