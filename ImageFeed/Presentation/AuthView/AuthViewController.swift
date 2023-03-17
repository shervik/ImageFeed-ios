//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 13.02.2023.
//

import UIKit

private enum Constants {
    static let anchorHorizontalButton: CGFloat = 16
    static let anchorBottomButton: CGFloat = 90
    static let buttonHeight: CGFloat = 48
    static let buttonCornerRadius: CGFloat = 16
    static let buttonFontSize: CGFloat = 17
}

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    private var safeArea: UILayoutGuide { view.safeAreaLayoutGuide }

    private lazy var imageView = UIImageView()
    private lazy var buttonEnter = UIButton(type: .custom)

    private var webViewViewController = WebViewViewController()
    weak var delegate: AuthViewControllerDelegate?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack

        webViewViewController.delegate = self

        configImage()
        configButton()
        configConstraint()
    }

    @objc private func didTapEnterButton() {
        navigationController?.pushViewController(webViewViewController, animated: true)
    }
}

// MARK: - AuthViewController WebViewVC Delegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }

    func webViewViewControllerDidCancel() {
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - AuthViewController Configuration
extension AuthViewController {
    private func configImage() {
        view.addSubview(imageView)

        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "AuthScreen")
    }

    private func configButton() {
        view.addSubview(buttonEnter)

        buttonEnter.setTitle("Войти", for: .normal)
        buttonEnter.setTitleColor(UIColor.ypBlack, for: .normal)
        buttonEnter.titleLabel?.font = UIFont.boldSystemFont(ofSize: Constants.buttonFontSize)
        buttonEnter.backgroundColor = .ypWhite
        buttonEnter.layer.masksToBounds = true
        buttonEnter.layer.cornerRadius = Constants.buttonCornerRadius
        buttonEnter.addTarget(self, action: #selector(didTapEnterButton), for: .touchUpInside)
    }

    private func configConstraint() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        buttonEnter.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),

            buttonEnter.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.anchorHorizontalButton),
            buttonEnter.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constants.anchorHorizontalButton),
            buttonEnter.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Constants.anchorBottomButton),
            buttonEnter.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
}
