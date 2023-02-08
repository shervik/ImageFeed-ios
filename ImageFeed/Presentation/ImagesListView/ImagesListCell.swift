//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 20.12.2022.
//

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

    private lazy var labelDate = UILabel()
    lazy var imageCell = UIImageView()
    lazy var likeButton = UIButton()
    lazy var gradientView = GradientView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        [imageCell, labelDate, likeButton, gradientView].forEach { subview in
            contentView.addSubview(subview)
        }

        contentView.contentMode = .center
        configureLayoutConstraint()
        configureImageView()
        configureLabel()
    }
}

// MARK: - ImagesListCell Configuration

extension ImagesListCell {
    private func configureLayoutConstraint() {
        imageCell.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.anchorCellVertical),
            imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.anchorCellHorizontal),
            imageCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.anchorCellHorizontal),
            imageCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.anchorCellVertical),

            likeButton.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: imageCell.topAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: Constants.anchorLikeHeight),

            labelDate.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor, constant: Constants.anchorLabelLeading),
            labelDate.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor, constant: -Constants.anchorLabelBottom),

            gradientView.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor),
            gradientView.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: Constants.anchorGradientHeight)
        ])
    }

    private func configureImageView() {
        imageCell.contentMode = .scaleAspectFill
        imageCell.clipsToBounds = true
        imageCell.layer.cornerRadius = Constants.cornerRadiys
    }

    private func configureLabel() {
        labelDate.text = Date().dateString
        labelDate.font.withSize(Constants.fontLabel)
        labelDate.textColor = .ypWhite
        labelDate.contentMode = .left
    }
}
