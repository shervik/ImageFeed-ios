//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 20.12.2022.
//

import UIKit
import Kingfisher

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

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let identifier = "ImagesListCell"

    weak var delegate: ImagesListCellDelegate?

    private lazy var labelDate = UILabel()
    private lazy var imageCell = UIImageView()
    private lazy var likeButton = UIButton()
    private lazy var gradientView = GradientView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.kf.cancelDownloadTask()
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)

        let gradientLayer = gradientView.gradientLayer
        let colors = [UIColor.ypBlack.withAlphaComponent(0),
                        UIColor.ypBlack.withAlphaComponent(1)]
        gradientView.addGradient(with: gradientLayer, colorSet: colors, locations: [0, 1])
    }

    func setIsLiked(_ isLiked: Bool) {
        likeButton.isSelected  = isLiked
    }
    
    private func setup() {
        [imageCell, labelDate, likeButton, gradientView].forEach { subview in
            contentView.addSubview(subview)
        }

        contentView.contentMode = .center
        configureLayoutConstraint()
        configureImageView()
        configureLabel()
        configureLikeButton()

    }

    @objc private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}

// MARK: - ImagesListCell Configuration

extension ImagesListCell {
    func configCell(for tableView: UITableView, from photos: PhotosViewModel, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let imageString = photo.thumbImageURL
        let urlImage = URL(string: imageString)

        let cache = ImageCache.default
        cache.memoryStorage.config.expiration = .seconds(1800)

        imageCell.kf.indicatorType = .activity
        imageCell.kf.setImage(with: urlImage,
                              placeholder: UIImage(named: "image_placeholder")) { result in
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        selectionStyle = .none
        backgroundColor = .clear

        setIsLiked(photos[indexPath.row].isLiked)

        if let dateCreated = photo.createdAt {
            labelDate.text = DateFormatter.longDateFormatter.string(from: dateCreated)
        }
    }

    private func configureLikeButton() {
        likeButton.setImage(UIImage(named: "like_disabled"), for: .normal)
        likeButton.setImage(UIImage(named: "like_active"), for: .selected)
        likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
    }

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
        labelDate.font.withSize(Constants.fontLabel)
        labelDate.textColor = .ypWhite
        labelDate.contentMode = .left
    }
}
