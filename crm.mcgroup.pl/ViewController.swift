//
//  ViewController.swift
//  crm.mcgroup.pl
//
//  Created by Pavel Misko on 30.11.22.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKNavigationDelegate, WKUIDelegate {
    var webView: WKWebView!
    var myURL: URL!
    var applicationNameForUserAgent: String?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.applicationNameForUserAgent = "google.com"
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 1200, height: 800), configuration: webConfiguration)
        webView.allowsBackForwardNavigationGestures = true;
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view = webView
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
//        let newBut = NSButton(frame: NSRect(x: 50, y: 200, width: 100, height: 30))
//        newBut.title = "Autofill"
//        newBut.target = self
//        newBut.action = #selector(ViewController.printSomething)
//        self.view.addSubview(newBut)
        myURL = URL(string: "https://google.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let compaire = URL(string: "url login")
        if(webView.url == compaire){
            var str = ""
            str.append("""
                            document.querySelectorAll('.login-email').forEach(i=>i.value='value');
                            document.querySelectorAll('.login-password').forEach(i=>i.value='value')
                            """)

            webView.evaluateJavaScript(str) {(result, error) in
                guard error == nil else {
                    print(error!)
                    return
                }
                print("!!!!!!_____!!!!!!!")
                print(String(describing: result))
            }
//
//            webView.evaluateJavaScript("localStorage.setItem(\"test\", \"testvalue\")") { (result, error) in
//
//            }
        }
        
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

