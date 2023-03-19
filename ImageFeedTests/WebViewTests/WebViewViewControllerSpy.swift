//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Виктория Щербакова on 17.03.2023.
//

import Foundation
import ImageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var loadRequestCalled = false

    func configure(_ presenter: WebViewPresenterProtocol) {
        presenter.view = self
    }

    func load(_ request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {

    }

    func setProgressHidden(_ isHidden: Bool) {

    }
}
