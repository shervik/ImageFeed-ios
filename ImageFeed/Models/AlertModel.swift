//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 17.01.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let primaryButtonText: String
    var primaryCompletion: (() -> Void)?
    let secondButtonText: String?
    var secondCompletion: (() -> Void)?
}
