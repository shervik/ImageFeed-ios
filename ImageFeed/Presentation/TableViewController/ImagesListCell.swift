//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 20.12.2022.
//

import Foundation
import UIKit

private enum Constants {
    static let anchorCellHorizontal: CGFloat = 16
    static let anchorCellVertical: CGFloat = 4
    static let anchorLabelBottom: CGFloat = 8
    static let anchorLabelLeading: CGFloat = 8
    static let anchorGradientHeight: CGFloat = 30
    static let anchorLikeHeight: CGFloat = 42
    static let cornerRadiys: CGFloat = 16
    static let fontLabel: CGFloat = 13
}

final class ImagesListCell: UITableViewCell {
    static let identifier = "ImagesListCell"

    lazy var imageCell = { UIImageView() }()
    lazy var likeButton = { UIButton() }()
    lazy var gradientView = { UIView() }()
    private lazy var labelDate = { UILabel() }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        contentView.contentMode = .center
        contentView.addSubview(imageCell)
        contentView.addSubview(labelDate)
        contentView.addSubview(likeButton)
        contentView.addSubview(gradientView)

        configureImageView()
        configureLabel()
        configureLikeButton()
        configureGradientLayer()
    }
    private func configureImageView() {
        imageCell.translatesAutoresizingMaskIntoConstraints = false
        imageCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.anchorCellVertical).isActive = true
        imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.anchorCellHorizontal).isActive = true
        imageCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.anchorCellHorizontal).isActive = true
        imageCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.anchorCellVertical).isActive = true
        imageCell.contentMode = .scaleAspectFill
        imageCell.clipsToBounds = true
        imageCell.layer.cornerRadius = Constants.cornerRadiys
    }

    private func configureLikeButton() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor).isActive = true
        likeButton.topAnchor.constraint(equalTo: imageCell.topAnchor).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: Constants.anchorLikeHeight).isActive = true
    }

    private func configureLabel() {
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        labelDate.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor, constant: Constants.anchorLabelLeading).isActive = true
        labelDate.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor, constant: -Constants.anchorLabelBottom).isActive = true
        labelDate.text = Date().dateString
        labelDate.font.withSize(Constants.fontLabel)
        labelDate.textColor = .ypWhite
        labelDate.contentMode = .left
    }

    func configureGradientLayer() {
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor).isActive = true
        gradientView.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor).isActive = true
        gradientView.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor).isActive = true
        gradientView.heightAnchor.constraint(equalToConstant: Constants.anchorGradientHeight).isActive = true
    }
}
