//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 11.03.2023.
//

import Foundation
import Kingfisher

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photo: PhotosViewModel? { get set }
    func getPhoto()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
    func presentAlert(with error: Error)
    func fetchPhotosNextPage()
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?

    var photo: PhotosViewModel?
    private var imagesListHelper: ImagesListHelperProtocol
    private var alertPresenter: AlertPresenterProtocol?

    init(imagesListHelper: ImagesListHelperProtocol, alert: AlertPresenterProtocol?) {
        self.imagesListHelper = imagesListHelper
        self.alertPresenter = alert
    }

    func fetchPhotosNextPage() {
        imagesListHelper.loadNextPage()
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        imagesListHelper.changeLike(photoId: photoId, isLike: isLike) { _ in
            completion(.success(()))
        }
    }

    func getPhoto() {
        guard let photoModel = imagesListHelper.photoModel else { return }
        photo = convertToViewModel(model: photoModel)
    }

    func presentAlert(with error: Error) {
        if let localized = error as? LocalizedError {
            let alertError = AlertModel(
                title: localized.errorDescription ?? "Что-то пошло не так(",
                message: localized.failureReason ?? error.localizedDescription,
                primaryButtonText: "Ок",
                primaryCompletion: nil,
                secondButtonText: nil,
                secondCompletion: nil
            )
            alertPresenter?.showAlert(alert: alertError)
        }
    }

    private func convertToViewModel(model: PhotoModel) -> PhotosViewModel {
        return model.map { photo in
            PhotoViewModel(
                id: photo.id,
                size: CGSize(width: photo.width, height: photo.height),
                createdAt: DateFormatter.isoDateFormatter.date(from: photo.createdAt ?? ""),
                welcomeDescription: photo.description ?? "Hey!!!",
                thumbImageURL: photo.urls.thumb,
                largeImageURL: photo.urls.full,
                isLiked: photo.likedByUser)
        }
    }
}
