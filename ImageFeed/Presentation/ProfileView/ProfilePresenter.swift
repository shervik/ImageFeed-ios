//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 23.01.2023.
//

import Foundation

protocol ProfilePresenterDelegate: AnyObject {
    func presentProfile(_ profile: ProfileModel?)
}

final class ProfilePresenter {
    private let profileService: ProfileService
    private weak var delegate : ProfilePresenterDelegate?
    private var alertPresenter: AlertPresenterProtocol?

    init(profileService: ProfileService, delegate: ProfilePresenterDelegate, alert: AlertPresenterProtocol) {
        self.profileService = profileService
        self.delegate = delegate
        self.alertPresenter = alert
    }

    func getSelfProfile() {
        profileService.fetchProfileData() { result in
            switch result {
            case .success(let body):
                let profileModel = ProfileModel(username: body.username,
                                                firstName: body.firstName,
                                                lastName: body.lastName,
                                                bio: body.bio)

                self.delegate?.presentProfile(profileModel)
            case .failure(let failure):
                print(failure)
            }
        }
    }

    func presentAlert() {
        let alertExit = AlertModel(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            primaryButtonText: "Да",
            primaryCompletion: { print("press yes") },
            secondButtonText: "Нет",
            secondCompletion:  { print("press no") })

        alertPresenter?.showAlert(alert: alertExit)
    }
}
