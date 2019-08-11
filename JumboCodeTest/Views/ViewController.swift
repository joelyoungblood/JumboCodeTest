//
//  ViewController.swift
//  JumboCodeTest
//
//  Created by Joel Youngblood on 8/9/19.
//  Copyright © 2019 Joel Youngblood. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import NSObject_Rx
import WebKit

final class ViewController: UIViewController {
    
    private let viewModel = ViewModel()
    
    private struct Constants {
        static let evaluationScript = "Jumbo.message()"
        static let testUrl = "https://www.github.com"
        static let verticalOffset: CGFloat = 75
        static let leadingTrailingOffset: CGFloat = 15
    }
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.text = "Loading..."
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var contentController = WKUserContentController()
    
    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.userContentController = self.contentController
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.verticalOffset)
            make.centerX.equalToSuperview()
            make.leading.lessThanOrEqualToSuperview().offset(Constants.leadingTrailingOffset)
            make.trailing.lessThanOrEqualToSuperview().inset(Constants.leadingTrailingOffset)
        }
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(statusLabel.snp.bottom).offset(Constants.leadingTrailingOffset)
        }
        
        if let testUrl = URL(string: Constants.testUrl) {
            let request = URLRequest(url: testUrl)
            webView.load(request)
        }
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.fetchAndValidateScript()
        
        viewModel.isLoading
            .observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] loading in
                if loading {
                    self?.statusLabel.text = "Loading"
                }
        }).disposed(by: rx.disposeBag)
        
        viewModel.validatedScript
            .observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] script in
                let userScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: true)
                self?.contentController.addUserScript(userScript)
            }).disposed(by: rx.disposeBag)
        
        viewModel.errorMessage
            .observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] error in
                self?.statusLabel.text = error.description
        }).disposed(by: rx.disposeBag)
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(Constants.evaluationScript) { [weak self] result, error in
            if let evalationError = error {
                print(evalationError.localizedDescription)
            } else {
                if let message = result as? String {
                    self?.statusLabel.text = "Evalauted injected script, message = \(message)"
                }
            }
        }
    }
}
