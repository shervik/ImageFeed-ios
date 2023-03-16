//
//  NavigationController.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 13.01.2023.
//

import UIKit

final class NavigationContoller: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
        navigationBar.isHidden = true
        navigationBar.backgroundColor = .ypBlack
        navigationBar.barTintColor = .ypBlack
        navigationBar.tintColor = .ypWhite
        self.view?.backgroundColor = .ypBlack
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return topViewController?.preferredStatusBarStyle ?? .lightContent
        }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
