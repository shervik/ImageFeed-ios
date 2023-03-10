//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 04.01.2023.
//

import UIKit
import Kingfisher

private enum Constants {
    static let anchorLeading: CGFloat = 16
    static let anchorTrailing: CGFloat = 24
    static let anchorTop: CGFloat = 32
    static let spacing: CGFloat = 8
}

protocol ProfileViewControllerProtocol: AnyObject {
    func showProfile(_ model: ProfileViewModel?)
    func showAvatar(urlImage: URL)
    func didExitFromAccount()
}

final class ProfileViewController: UIViewController {
    private var safeArea: UILayoutGuide { view.safeAreaLayoutGuide }
    
    private var profilePresenter: ProfilePresenterProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?

    private lazy var avatarImage = UIImageView()
    private lazy var personalNameLabel = UILabel()
    private lazy var nicknameLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var exitButton = UIButton()

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
        profilePresenter = ProfilePresenter(viewController: self, alert: AlertPresenter(delegate: self))
        profilePresenter?.presentProfile()

        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.profilePresenter?.updateAvatar()
            }
        profilePresenter?.updateAvatar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configStackView()
        configExitButton()
        configAvatar()
    }

    @objc private func didTapExitButton() {
        profilePresenter?.presentAlert()
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

    private func configExitButton() {
        exitButton.setImage(UIImage(named: "exit"), for: .normal)
        exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
    }

    private func configLabel(_ label: UILabel, text: String, font: UIFont? = UIFont.sfRegular) {
        label.text = text
        label.font = font
        label.textColor = .ypWhite
        nicknameLabel.textColor = .ypGray
        personalNameLabel.numberOfLines = 2
        personalNameLabel.addCharactersSpacing(-0.08)
        descriptionLabel.numberOfLines = 5
    }

    private func configAvatar() {
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70)
        ])
        avatarImage.contentMode = .scaleAspectFill
    }
}

// MARK: - Action

extension ProfileViewController: ProfileViewControllerProtocol {
    func didExitFromAccount() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func showAvatar(urlImage: URL) {
        let cache = ImageCache.default
        cache.memoryStorage.config.expiration = .seconds(1800)

        avatarImage.kf.indicatorType = .activity
        let processor = RoundCornerImageProcessor(cornerRadius: 60)
        avatarImage.kf.setImage(with: urlImage,
                                placeholder: UIImage(named: "avatar_placeholder"),
                                options: [.processor(processor)])
    }
    
    func showProfile(_ model: ProfileViewModel?) {
        guard let model = model else { return }
        configLabel(personalNameLabel, text: model.fullName, font: UIFont.sfBold)
        configLabel(nicknameLabel, text: model.loginName)
        configLabel(descriptionLabel, text: model.bio)
    }
}
