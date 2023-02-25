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

final class WebViewViewController: UIViewController {
    private var safeArea: UILayoutGuide { view.safeAreaLayoutGuide }

    weak var delegate: WebViewViewControllerDelegate?

    private lazy var webView = WKWebView()
    private lazy var buttonBack = UIButton(type: .custom)
    private lazy var progressView = UIProgressView(progressViewStyle: .default)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        webView.removeObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            context: nil
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite

        webView.navigationDelegate = self
        loadWebRequest()

        configWebView()
        configButton()
        configProgress()
        configConstraint()
    }

    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    private func loadWebRequest() {
        var urlComponents = URLComponents(string: unsplashAuthorizeURLString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: accessScope)
        ]
        guard let url = urlComponents?.url else { return }

        DispatchQueue.main.async {
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
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
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

// MARK: - WebViewViewController Configuration
extension WebViewViewController {
    private func configWebView() {
        view.addSubview(webView)
        webView.backgroundColor = .ypWhite
    }

    private func configButton() {
        view.addSubview(buttonBack)

        guard let navBackButton = UIImage(named: "nav_back_button") else { return }
        buttonBack.setImage(navBackButton.withTintColor(.ypBlack), for: .normal)
        buttonBack.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }

    private func configProgress() {
        view.addSubview(progressView)

        progressView.progressTintColor = .ypBlack
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
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
