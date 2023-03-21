//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Виктория Щербакова on 13.02.2023.
//

import UIKit
import WebKit

private enum Constant {
    static let anchorButtonBack: CGFloat = 9
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel()
}

protocol WebViewViewControllerProtocol: AnyObject {
    func load(_ request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
    func configure(_ presenter: WebViewPresenterProtocol)
}

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {
    private var safeArea: UILayoutGuide { view.safeAreaLayoutGuide }

    weak var delegate: WebViewViewControllerDelegate?
    private var presenter: WebViewPresenterProtocol?
    private var estimatedProgressObservation: NSKeyValueObservation?

    private lazy var webView = WKWebView()
    private lazy var buttonBack = UIButton(type: .custom)
    private lazy var progressView = UIProgressView()

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .ypWhite
        configWebView()
        configButton()
        configProgress()
        configConstraint()

        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [.new]) { [weak self] _, _ in
                 guard let self = self else { return }
                 self.presenter?.didUpdateProgressValue(self.webView.estimatedProgress)
             }
    }

    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                dataStore.removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }

    func configure(_ presenter: WebViewPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }

    func load(_ request: URLRequest) {
        webView.load(request)
    }

    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }

    @objc private func didTapBackButton() {
        delegate?.webViewViewControllerDidCancel()
    }
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}

// MARK: - WebViewViewController Configuration
extension WebViewViewController {
    private func configWebView() {
        view.addSubview(webView)
        webView.backgroundColor = .ypWhite
        webView.accessibilityIdentifier = "UnsplashWebView"
    }

    private func configButton() {
        view.addSubview(buttonBack)

        guard let navBackButton = UIImage(named: "nav_back_button") else { return }
        buttonBack.setImage(navBackButton.withTintColor(.ypBlack), for: .normal)
        buttonBack.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }

    private func configProgress() {
        view.addSubview(progressView)

        progressView.tintColor = .ypBlack
        progressView.trackTintColor = .ypBackground
    }

    private func configConstraint() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        buttonBack.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            buttonBack.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Constant.anchorButtonBack),
            buttonBack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.anchorButtonBack),

            progressView.topAnchor.constraint(equalTo: buttonBack.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
