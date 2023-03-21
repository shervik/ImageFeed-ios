//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Виктория Щербакова on 19.03.2023.
//

import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {

    func testPresenterCallsFetchPhotosNextPage() {
        //given
        let imagesListHelper = ImagesListHeplerSpy()
        let presenter = ImagesListPresenter(imagesListHelper: imagesListHelper, alert: nil)

        //when
        presenter.fetchPhotosNextPage()

        //then
        XCTAssertTrue(imagesListHelper.nextPageIsLoad)
    }
    
    func testPresenterCallsIsLiked() {
        //given
        let imagesListHepler = ImagesListHeplerSpy()
        let presenter = ImagesListPresenter(imagesListHelper: imagesListHepler, alert: nil)
        let photoMock = PhotoMock.photos

        //when
        presenter.changeLike(photoId: photoMock[0].id, isLike: !photoMock[0].isLiked) { _ in }

        //then
        XCTAssertTrue(imagesListHepler.likeIsChanged)
    }
}
