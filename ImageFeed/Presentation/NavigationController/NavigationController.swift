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
        navigationBar.backgroundColor = .ypBlack
        navigationBar.barTintColor = .ypBlack
        navigationBar.tintColor = .ypWhite
        self.view?.backgroundColor = .ypBlack
    }
}
