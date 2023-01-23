//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 04.01.2023.
//

import UIKit

private enum Constants {
    static let anchorLeading: CGFloat = 16
    static let anchorTrailing: CGFloat = 24
    static let anchorTop: CGFloat = 32
    static let spacing: CGFloat = 8
}

final class ProfileViewController: UIViewController {
    private var safeArea: UILayoutGuide { view.safeAreaLayoutGuide }

    private var alertPresenter: AlertPresenterProtocol?
    private var profilePresenter: ProfileProtocol?

    private lazy var avatarImage = { UIImageView() }()
    private lazy var personalNameLabel = { UILabel() }()
    private lazy var nicknameLabel = { UILabel() }()
    private lazy var descriptionLabel = { UILabel() }()
    private lazy var exitButton = { UIButton() }()

    private lazy var stackViewVertical = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.spacing
        return stackView
    }()

    private lazy var stackViewHorizontal = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        [avatarImage, exitButton].forEach { item in
            stackView.addArrangedSubview(item)
        }
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        alertPresenter = AlertPresenter(delegate: self)
        profilePresenter = ProfilePresenter()
        guard let model = profilePresenter?.profileModel else { return }

        configStackView()
        configExitButton()

        configAvatar(model.avatar)
        configLabel(personalNameLabel, text: model.fullName, font: UIFont.sfDisplayBold)
        configLabel(nicknameLabel, text: model.nickname)
        configLabel(descriptionLabel, text: model.description)
    }

    @objc private func didTapExitButton() {
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

// MARK: - ProfileView Configurations

extension ProfileViewController {
    private func configStackView() {
        [stackViewHorizontal, personalNameLabel, nicknameLabel, descriptionLabel].forEach { item in
            stackViewVertical.addArrangedSubview(item)
        }

        view.addSubview(stackViewHorizontal)
        view.addSubview(stackViewVertical)

        stackViewHorizontal.translatesAutoresizingMaskIntoConstraints = false
        stackViewVertical.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackViewVertical.topAnchor.constraint(equalTo: stackViewHorizontal.bottomAnchor, constant: Constants.spacing),
            stackViewVertical.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.anchorLeading),
            stackViewVertical.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constants.anchorTrailing),

            stackViewHorizontal.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Constants.anchorTop),
            stackViewHorizontal.leadingAnchor.constraint(equalTo: stackViewVertical.leadingAnchor),
            stackViewHorizontal.trailingAnchor.constraint(equalTo: stackViewVertical.trailingAnchor),
        ])
    }

    private func configAvatar(_ avatar: UIImage) {
        avatarImage.image = avatar
        avatarImage.contentMode = .scaleAspectFit
        avatarImage.tintColor = .gray
    }

    private func configExitButton() {
        exitButton.setImage(UIImage(named: "exit"), for: .normal)
        exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
    }

    private func configLabel(_ label: UILabel, text: String, font: UIFont? = UIFont.sfDisplayRegular) {
        label.text = text
        label.font = font
        label.textColor = .ypWhite
        nicknameLabel.textColor = .ypGray
        personalNameLabel.numberOfLines = 2
        personalNameLabel.addCharactersSpacing(-0.08)
        descriptionLabel.numberOfLines = 5
    }
}
