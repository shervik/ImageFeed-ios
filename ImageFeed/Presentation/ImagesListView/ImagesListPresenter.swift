//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 11.03.2023.
//

import UIKit
import Kingfisher

protocol ImagesListPresenterProtocol: AnyObject {
    func addObserver(_ tableView: UITableView)
    func getPhoto() -> PhotosViewModel?
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
    var imagesService: ImagesListServiceProtocol? { get }
    func presentAlert(with error: Error)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    private weak var viewController: ImagesListViewController?
    private(set) var imagesService: ImagesListServiceProtocol?
    private var imageServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenterProtocol?

    init(imagesService: ImagesListServiceProtocol, viewController: ImagesListViewController, alert: AlertPresenterProtocol) {
        self.imagesService = imagesService
        self.viewController = viewController
        self.alertPresenter = alert
    }

    func addObserver(_ tableView: UITableView) {
        imageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    self?.viewController?.updateTableViewAnimated()
                }
        imagesService?.fetchPhotosNextPage()
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        imagesService?.changeLike(photoId: photoId, isLike: isLike) { _ in
            completion(.success(()))
        }
    }

    func getPhoto() -> PhotosViewModel? {
        guard let photoModel = imagesService?.photos else { return nil}
        return convertToViewModel(model: photoModel)
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
