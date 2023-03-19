//
//  WebViewTests.swift
//  ImageFeedTests
//
//  Created by Виктория Щербакова on 17.03.2023.
//

import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        //given
        let webViewController = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        webViewController.configure(presenter)

        //when
        _ = webViewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    } 

    func testPresenterCallsLoadRequest() {
        //given
        let webViewController = WebViewViewControllerSpy()
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        webViewController.configure(presenter)

        //when
        presenter.viewDidLoad()

        //then
        XCTAssertTrue(webViewController.loadRequestCalled)
    }

    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6

        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)

        //then
        XCTAssertFalse(shouldHideProgress)
    }

    func testProgressHiddenWhenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0

        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)

        //then
        XCTAssertTrue(shouldHideProgress)
    }

    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)

        //when
        let url = authHelper.authURL()
        guard let urlString = url?.absoluteString else { return }

        //then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }

    func testCodeFromURL() {
        //given
        let authHelper = AuthHelper()

        //when
        var urlComponents = URLComponents(string: "https://unsplash.com")
        urlComponents?.path = "/oauth/authorize/native"
        urlComponents?.queryItems = [URLQueryItem(name: "code", value: "test code")]

        guard let url = urlComponents?.url else { return }
        let code = authHelper.code(from: url)

        //then
        XCTAssertEqual(code, "test code")
    }
}
