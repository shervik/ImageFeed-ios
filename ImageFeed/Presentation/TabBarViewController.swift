//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 13.01.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        tabBar.barTintColor = .ypBlack
        tabBar.tintColor = .ypWhite
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let imagesListItem = ImagesListViewController()
        let profileItem = ProfileViewController()

        let iconMain = UITabBarItem(title: nil, image: UIImage(named: "tab_editorial_disabled"), selectedImage: UIImage(named: "tab_editorial_active"))
        let iconProfile = UITabBarItem(title: nil, image: UIImage(named: "tab_profile_disabled"), selectedImage: UIImage(named: "tab_profile_active"))

        imagesListItem.tabBarItem = iconMain
        profileItem.tabBarItem = iconProfile

        self.viewControllers = [NavigationContoller(rootViewController: imagesListItem), profileItem]
    }
}
