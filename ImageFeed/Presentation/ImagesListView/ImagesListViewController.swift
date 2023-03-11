//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 20.12.2022.
//

import UIKit

final class ImagesListViewController: UIViewController {
    private var safeArea: UILayoutGuide { view.safeAreaLayoutGuide }
    private let photos: [String] = Array(0..<20).map{ "\($0)" }

    private let imagesService = ImagesListService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        configTable()
    }
}

// MARK: - ImagesListView Configuration

extension ImagesListViewController {
    private func configTable() {
        let tableView = UITableView(frame: .null, style: .plain)
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.identifier)
    }

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photo = UIImage(named: photos[indexPath.row]) else { return }

        cell.selectionStyle = .none
        cell.imageCell.image = photo
        cell.backgroundColor = .clear

        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "like_active") : UIImage(named: "like_disabled")
        cell.likeButton.setImage(likeImage, for: .normal)

        let gradientLayer = GradientView(frame: view.bounds)
        cell.gradientView.layer.addSublayer(gradientLayer.gradientLayer)
    }
}

// MARK: - ImagesListView DataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.identifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }

        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

// MARK: - ImagesListView Delegate 

extension ImagesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photos[indexPath.row]) else { return 0 }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesService.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleImageView = SingleImageViewController()
        singleImageView.image = UIImage(named: photos[indexPath.row]) ?? UIImage()
        singleImageView.modalPresentationStyle = .fullScreen
        singleImageView.modalTransitionStyle = .coverVertical
        present(singleImageView, animated: true, completion: nil)
    }
}
