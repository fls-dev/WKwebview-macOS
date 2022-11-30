//
//  ViewController.swift
//  crm.mcgroup.pl
//
//  Created by Pavel Misko on 30.11.22.
//

import Cocoa
import WebKit
import SafariServices

class ViewController: NSViewController, WKNavigationDelegate, WKUIDelegate {
    var webView: WKWebView!
    var myURL: URL!
    var applicationNameForUserAgent: String?

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.applicationNameForUserAgent = "crm.mcgroup"
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 1200, height: 800), configuration: webConfiguration)
        webView.allowsBackForwardNavigationGestures = true;
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view = webView
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        
        //        myURL = URL(string: "https://kodim.pl/ru/testid/")
        myURL = URL(string: "https://crm.mcgroup.pl/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            if let title = webView.title {
                self.view.window?.title = title
                self.view.window?.update()
            }
        }
        if let url = webView.url {
            print(url)
        }
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
        
}

