//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 20.12.2022.
//

import UIKit

class ImagesListViewController: UIViewController {
    private var safeArea: UILayoutGuide { view.safeAreaLayoutGuide }
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        configTable()
    }

    private func configTable() {
        let tableView = UITableView(frame: .null, style: .plain)
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.identifier)
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photo = UIImage(named: photosName[indexPath.row]) else { return }

        cell.selectionStyle = .none
        cell.imageCell.image = photo
        cell.backgroundColor = .clear

        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "LikeActive") : UIImage(named: "LikeNoActive")
        cell.likeButton.setImage(likeImage, for: .normal)

        let gradientLayer = CAGradientLayer.createGradientLayer(frame: view.bounds)
        gradientLayer.frame.size.height = 30
        cell.gradientView.layer.addSublayer(gradientLayer)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
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

extension ImagesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Подсказка: Высота ImageView будет ровно во столько же раз больше высоты image, во сколько раз ширина ImageView больше ширины image.

        guard let image = UIImage(named: photosName[indexPath.row]) else { return 0 }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }

}
