//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 20.02.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    private let oauth2Service = OAuth2Service()

    private var tabBarViewController: TabBarViewController?
    private var authViewController: AuthViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        authViewController = AuthViewController()
        authViewController?.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if OAuth2TokenStorage().token == nil {
            guard let authViewController = authViewController else { return }
            navigationController?.pushViewController(authViewController, animated: true)
        } else {
            switchToTabBarController()
        }
    }

    private func switchToTabBarController() {
        tabBarViewController = TabBarViewController()
        guard let tabBarViewController = tabBarViewController else { return }
        navigationController?.pushViewController(tabBarViewController, animated: true)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }

    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure:
                break
            }
        }
    }
}
