//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 11.03.2023.
//

import Foundation

final class ImagesListPresenter {
    private func convertToViewModel(model: PhotoModel) -> PhotoViewModel {
        let model = model[0]
        return PhotoViewModel(id: model.id,
                              size: CGSize(width: model.width, height: model.height),
                              createdAt: model.createdAt,
                              welcomeDescription: model.description,
                              thumbImageURL: "",
                              largeImageURL: "",
                              isLiked: model.likedByUser)
    }}
