//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Виктория Щербакова on 18.03.2023.
//

import XCTest

extension XCUIElement {
    func forceTap() {
        if self.isHittable {
            self.tap()
        }
        else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx:0.5, dy:0.5))
            coordinate.tap()
        }
    }
}

final class ImageFeedUITests: XCTestCase {

    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        sleep(3)

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))

        loginTextField.tap()
        loginTextField.typeText("")
        loginTextField.swipeUp()

        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))

        passwordTextField.tap()
        passwordTextField.typeText("")
        passwordTextField.swipeUp()

        webView.buttons["Login"].tap()

        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }

    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 2))

        let cellForLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cellForLike.swipeUp()
        XCTAssertTrue(cellForLike.waitForExistence(timeout: 5))

        cellForLike.buttons["LikeButton"].forceTap()
        sleep(5)
        cellForLike.buttons["LikeButton"].forceTap()
        sleep(5)

        cellForLike.tap()
        sleep(2)

        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        sleep(2)
        image.pinch(withScale: 0.5, velocity: -1)
        sleep(2)

        app.buttons["Back"].tap()
    }

    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.staticTexts["Victoria Scher"].exists)
        XCTAssertTrue(app.staticTexts["@gesvik"].exists)

        app.buttons["Exit"].tap()

        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()

        sleep(2)
        XCTAssertTrue(app.staticTexts["Войти"].exists)
    }
}
