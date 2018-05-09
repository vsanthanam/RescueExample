//
//  RescueViewController.swift
//  Rescue-Swift
//
//  Created by Varun Santhanam on 5/9/18.
//

import UIKit
import WebKit
import os.log

enum RescueViewControllerState {
    
    case initial
    case loading
    case loaded
    case error
    
}


class RescueViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView?
    var state: RescueViewControllerState {
        didSet {
            self.updateState()
        }
    }
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    required init?(coder aDecoder: NSCoder) {
        
        self.state = .initial
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setUpUI()
        self.updateState()

    }
    
    private func setUpUI() {
        
        self.setUpWebView()
        
    }
    
    private func setUpWebView() {
        
        let config = WKWebViewConfiguration()
        
        self.webView = WKWebView(frame: .zero, configuration: config)
        self.webView?.translatesAutoresizingMaskIntoConstraints = false
        self.webView?.allowsLinkPreview = false
        self.webView?.allowsBackForwardNavigationGestures = false
        
        self.view.addSubview(self.webView!)
        
        let guide = self.view.safeAreaLayoutGuide
        
        self.webView?.widthAnchor.constraint(equalTo: guide.widthAnchor).isActive = true
        self.webView?.heightAnchor.constraint(equalTo: guide.heightAnchor).isActive = true
        self.webView?.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        self.webView?.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
        
        self.webView?.navigationDelegate = self
        
    }
    
    private func updateState() {
        
        if self.state == .initial {
            
            self.loadWebApp()
            
        } else if self.state == .loading {
            
            self.loadingIndicator.startAnimating()
            self.webView?.isHidden = true
            
        } else if self.state == .loaded {
            
            self.webView?.isHidden = false
            self.loadingIndicator.stopAnimating()

            
        } else if self.state == .error {
            
            self.loadingIndicator.stopAnimating()
            self.webView?.isHidden = true

        }
        
    }
    
    private func loadWebApp() {
        
        var request = URLRequest(url: RescueConfig.rescueURL)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        self.webView?.load(request)
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        os_log("Failed Navigation: %@", log: RescueLog.defaultLog, type: .error, error.localizedDescription)
        
        self.state = .error

    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        os_log("Failed Provisional Navigation: %@", log: RescueLog.defaultLog, type: .error, error.localizedDescription)

        self.state = .error
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        os_log("Starting Provisional Navigation to %@", log: RescueLog.defaultLog, type: .info, (webView.url?.absoluteString)!)
        
        self.state = .loading
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        os_log("Finished Navigation to %@", log: RescueLog.defaultLog, type: .info, (webView.url?.absoluteString)!)
        
        self.state = .loaded
        
    }
    
}
