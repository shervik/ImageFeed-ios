//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 13.01.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    private var profileController: ProfileViewController?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        tabBar.barTintColor = .ypBlack
        tabBar.tintColor = .ypWhite
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let imagesListController = ImagesListViewController()
        let imagesListPresenter = ImagesListPresenter(imagesListHelper: ImagesListHelper(),
                                                      alert: AlertPresenter(delegate: self))
        imagesListController.configure(imagesListPresenter)

        let profileController = ProfileViewController()
        let profilePresenter = ProfilePresenter(alert: AlertPresenter(delegate: self))
        profileController.configure(profilePresenter)

        let iconMain = UITabBarItem(title: nil,
                                    image: UIImage(named: "tab_editorial_disabled"),
                                    selectedImage: UIImage(named: "tab_editorial_active")
        )
        let iconProfile = UITabBarItem(title: nil,
                                       image: UIImage(named: "tab_profile_disabled"),
                                       selectedImage: UIImage(named: "tab_profile_active")
        )
        imagesListController.tabBarItem = iconMain
        profileController.tabBarItem = iconProfile

        self.viewControllers = [NavigationContoller(rootViewController: imagesListController), profileController]
    }
}
