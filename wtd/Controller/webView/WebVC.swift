//
//  WebVC.swift
//  wtd
//
//  Created by chulyeon kim on 2023/08/18.
//

import UIKit
import WebKit

class WebVC: UIViewController {
    var urlString: String?
    private var webView: WKWebView!
    private let indicatorView: UIActivityIndicatorView = {
        let iv = UIActivityIndicatorView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.hidesWhenStopped = true
        iv.isHidden = false
        iv.color = UIColor.primary
        iv.startAnimating()
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        configWebView()
    }
}

//MARK: - func ==================
extension WebVC {
    private func setLayout() {
        view.backgroundColor = .myWhite
        
        webView = WKWebView()
        webView.isHidden = true
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        view.addSubview(indicatorView)
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func configWebView() {
        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

extension WebVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("\(error.localizedDescription) :::::::❌")
        dismiss(animated: true)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("\(error.localizedDescription) :::::::❌")
        dismiss(animated: true)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicatorView.isHidden = true
        webView.isHidden = false
    }
}
