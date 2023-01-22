//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 17.01.2023.
//

import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func showAlert(alert: AlertModel)
}

final class AlertPresenter: AlertPresenterProtocol {
    private weak var viewController: UIViewController?

    init(delegate: UIViewController?) {
        self.viewController = delegate
    }

    func showAlert(alert: AlertModel) {

        let alertContoller = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: .alert)

        let oneAction = UIAlertAction(
            title: alert.primaryButtonText,
            style: .default) { _ in
                alert.primaryCompletion?()
            }
        alertContoller.addAction(oneAction)

        if let secondButton = alert.secondButtonText {
            let otherAction = UIAlertAction(
                title: secondButton,
                style: .default) { _ in
                    alert.secondCompletion?()
                }
            alertContoller.addAction(otherAction)
        }

        alertContoller.view.accessibilityIdentifier = "Alert"
        viewController?.present(alertContoller, animated: true)
    }
}
