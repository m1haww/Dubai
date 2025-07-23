import UIKit
import WebKit
import SwiftUI

class ParkWebViewController: UIViewController {
    
    var parkName: String = ""
    var urlString: String = ""
    
    private var webView: WKWebView!
    private var activityIndicator: UIActivityIndicatorView!
    private var noInternetView: UIView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences.javaScriptEnabled = true
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadWebPage()
    }
    
    private func setupUI() {
        // Navigation bar setup
        navigationController?.navigationBar.backgroundColor = UIColor(red: 112/255, green: 60/255, blue: 241/255, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = UIColor(red: 112/255, green: 60/255, blue: 241/255, alpha: 1.0)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        title = parkName
        
        // Custom back button
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        // Activity indicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        // No internet view
        setupNoInternetView()
    }
    
    private func setupNoInternetView() {
        noInternetView = UIView()
        noInternetView.backgroundColor = .systemBackground
        noInternetView.isHidden = true
        noInternetView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noInternetView)
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: "wifi.slash")
        iconImageView.tintColor = .systemGray
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        noInternetView.addSubview(iconImageView)
        
        let titleLabel = UILabel()
        titleLabel.text = "No Internet Connection"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        noInternetView.addSubview(titleLabel)
        
        let messageLabel = UILabel()
        messageLabel.text = "Please check your internet connection and try again."
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        noInternetView.addSubview(messageLabel)
        
        let retryButton = UIButton(type: .system)
        retryButton.setTitle("Retry", for: .normal)
        retryButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        retryButton.backgroundColor = UIColor(red: 112/255, green: 60/255, blue: 241/255, alpha: 1.0)
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.layer.cornerRadius = 25
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        noInternetView.addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            noInternetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noInternetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            iconImageView.centerXAnchor.constraint(equalTo: noInternetView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: noInternetView.centerYAnchor, constant: -80),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: noInternetView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: noInternetView.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: noInternetView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: noInternetView.trailingAnchor, constant: -20),
            
            retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30),
            retryButton.centerXAnchor.constraint(equalTo: noInternetView.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 120),
            retryButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func loadWebPage() {
        guard let url = URL(string: urlString) else { return }
        
        // Show loading indicator
        activityIndicator.startAnimating()
        noInternetView.isHidden = true
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc private func backButtonTapped() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func retryButtonTapped() {
        loadWebPage()
    }
    
    private func isValidDomain(_ url: URL) -> Bool {
        guard let host = url.host else { return false }
        return host.contains("yourdomain.com")
    }
}

// MARK: - WKNavigationDelegate
extension ParkWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
        noInternetView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        
        // Check if it's a network error
        if (error as NSError).code == NSURLErrorNotConnectedToInternet ||
           (error as NSError).code == NSURLErrorTimedOut ||
           (error as NSError).code == NSURLErrorCannotConnectToHost {
            noInternetView.isHidden = false
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        // Handle tel: links
        if url.scheme == "tel" {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            decisionHandler(.cancel)
            return
        }
        
        // Handle external links (open in Safari)
        if !isValidDomain(url) && navigationAction.navigationType == .linkActivated {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            decisionHandler(.cancel)
            return
        }
        
        // Allow navigation within allowed domain
        if isValidDomain(url) || navigationAction.navigationType == .other {
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
        }
    }
}

// MARK: - WKUIDelegate
extension ParkWebViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        // Handle popup windows - load in the same webview
        if let url = navigationAction.request.url {
            webView.load(URLRequest(url: url))
        }
        
        return nil
    }
}