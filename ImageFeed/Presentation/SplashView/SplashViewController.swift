//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 20.02.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oauth2Service = OAuth2Service.shared
    private var tabBarViewController: TabBarController?
    private var authViewController: AuthViewController?
    private var alertPresenter: AlertPresenterProtocol?
    private let oauth2TokenStorage = OAuth2TokenStorage()

    private lazy var splashImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        alertPresenter = AlertPresenter(delegate: self)
        authViewController = AuthViewController()
        authViewController?.delegate = self
        configImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = oauth2TokenStorage.token {
            fetchProfile(token)
        } else {
            let authViewController = AuthViewController()
            authViewController.delegate = self

            navigationController?.pushViewController(authViewController, animated: true)
        }
    }
    
    private func switchToTabBarController() {
        navigationController?.pushViewController(TabBarController(), animated: true)
    }

    private func configImage() {
        view.addSubview(splashImage)

        splashImage.contentMode = .scaleAspectFit
        splashImage.image = UIImage(named: "LauchScreen")

        splashImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            splashImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) { [weak self] in
            UIBlockingProgressHUD.show()
            self?.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let token):
                self.fetchProfile(token)
            case .failure:
                self.presentAlert()
                break
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        profileService.fetchProfileData(token) { result in
            switch result {
            case .success(let body):
                self.profileImageService.fetchProfileImageURL(username: body.username) { _ in }
                self.switchToTabBarController()
            case .failure:
                self.presentAlert()
            }
        }
    }

    private func presentAlert() {
        let alertError = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            primaryButtonText: "Ок",
            primaryCompletion: { print("press yes") },
            secondButtonText: nil,
            secondCompletion: nil
        )

        alertPresenter?.showAlert(alert: alertError)
    }
}
