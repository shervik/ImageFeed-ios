//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 13.01.2023.
//

import UIKit

private enum Constants {
    static let anchorButtonBack: CGFloat = 9
    static let anchorButtonSharingBottom: CGFloat = 17
}

final class SingleImageViewController: UIViewController {
    private var safeArea: UILayoutGuide { view.safeAreaLayoutGuide }

    private lazy var imageView = UIImageView()
    private lazy var buttonBack = UIButton(type: .custom)
    private lazy var buttonSharing = UIButton(type: .custom)
    private lazy var scrollView = UIScrollView()
    lazy var image = { UIImage() }() {
        didSet {
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack

        congigScrollView()
        configImage()
        configButtons()
        configConstraint()
    }

    @objc private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func didTapShareButton() {
        let activityViewController = UIActivityViewController(activityItems: [image as Any], applicationActivities: nil)
        activityViewController.overrideUserInterfaceStyle = .dark
        present(activityViewController, animated: true)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

// MARK: - SingleImageView Configurations
extension SingleImageViewController {
    private func configImage() {
        scrollView.addSubview(imageView)

        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
    }

    private func congigScrollView() {
        view.addSubview(scrollView)

        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }

    private func configButtons() {
        view.addSubview(buttonBack)
        view.addSubview(buttonSharing)
        
        buttonBack.setImage(UIImage(named: "back"), for: .normal)
        buttonBack.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        buttonSharing.setImage(UIImage(named: "sharing"), for: .normal)
        buttonSharing.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
    }

    private func configConstraint() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        buttonBack.translatesAutoresizingMaskIntoConstraints = false
        buttonSharing.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            buttonBack.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Constants.anchorButtonBack),
            buttonBack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.anchorButtonBack),

            buttonSharing.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            buttonSharing.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Constants.anchorButtonSharingBottom),
        ])
    }
}
