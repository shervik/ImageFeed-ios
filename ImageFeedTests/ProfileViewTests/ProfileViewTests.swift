//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Виктория Щербакова on 17.03.2023.
//

import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {
    
    func testPresenterConvertModel() {
        let viewController = ProfileViewControllerSpy()
        let sut = ProfilePresenter(alert: AlertPresenter(delegate: nil))
        viewController.configure(sut)

        let model = ProfileModel(username: "first_test", firstName: "Test", lastName: "Last")
        let viewModel = sut.convertToViewModel(model: model)

        XCTAssertEqual(viewModel.username, model.username)
        XCTAssertEqual(viewModel.fullName, "\(model.firstName) \(model.lastName)")
        XCTAssertEqual(viewModel.loginName, "@\(model.username)")
    }
}
