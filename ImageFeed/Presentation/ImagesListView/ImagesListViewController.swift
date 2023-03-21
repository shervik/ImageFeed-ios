//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 20.12.2022.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    func configure(_ presenter: ImagesListPresenterProtocol)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    private var safeArea: UILayoutGuide { view.safeAreaLayoutGuide }

    private let tableView = UITableView(frame: .null, style: .plain)
    private lazy var photos: PhotosViewModel = []
    private var imageServiceObserver: NSObjectProtocol?

    private var presenter: ImagesListPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    self?.updateTableViewAnimated()
                }
        presenter?.fetchPhotosNextPage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .ypBlack
        configTable()
    }

    func configure(_ presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }

    private func updateTableViewAnimated() {
        presenter?.getPhoto()
        let oldCount = photos.count
        let newCount = presenter?.photo?.count ?? 0

        photos = presenter?.photo ?? []

        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map {
                    IndexPath(row: $0, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
}

// MARK: - ImagesListView Configuration

extension ImagesListViewController {
    private func configTable() {
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
}

// MARK: - ImagesListView DataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.identifier, for: indexPath)as? ImagesListCell
        else { return UITableViewCell() }
        
        cell.delegate = self
        cell.configCell(for: tableView, from: photos, with: indexPath)
        
        return cell
    }
}

// MARK: - ImagesListView Delegate 

extension ImagesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            presenter?.fetchPhotosNextPage()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let largeImageURL = URL(string: photos[indexPath.row].largeImageURL) else { return }
        let singleImageView = SingleImageViewController()
        singleImageView.largeImageURL = largeImageURL
        singleImageView.showLargeImage()
        singleImageView.modalPresentationStyle = .fullScreen
        singleImageView.modalTransitionStyle = .coverVertical
        present(singleImageView, animated: true, completion: nil)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {

    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]

        UIBlockingProgressHUD.show()

        presenter?.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.photos = self.presenter?.photo ?? []
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
            case .failure(let error):
                self.presenter?.presentAlert(with: error)
            }

            UIBlockingProgressHUD.dismiss()
        }
    }
}
