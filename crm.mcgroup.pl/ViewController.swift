//
//  ViewController.swift
//  crm.mcgroup.pl
//
//  Created by Pavel Misko on 30.11.22.
//

import Cocoa
import WebKit
import PDFKit

@available(macOS 11.3, *)
class ViewController: NSViewController, WKNavigationDelegate, WKUIDelegate, URLSessionDelegate, WKDownloadDelegate, PDFViewDelegate {
      
    var webView: WKWebView!
    var myURL: URL!
    
    
    let printInfo = NSPrintInfo.shared
  
    override func loadView() {
        super.loadView()
        view = WKWebView(frame:self.view.frame)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = WKWebsiteDataStore.default()
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 1200, height: 800), configuration: webConfiguration)
        webView.frame.size = CGSize(width: 1200, height: 800)
        webView.allowsBackForwardNavigationGestures = true;
        webView.navigationDelegate = self
        webView.uiDelegate = self
        self.printInfo.paperSize = CGSize(width: 792.0, height: 612.0)
        view = webView
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
       

        let newBut = NSButton(frame: NSRect(x: 500, y: 0, width: 100, height: 30))
        newBut.title = "PRINT"
        newBut.target = self
        newBut.action = #selector(ViewController.printSomething)
        self.view.addSubview(newBut)
        
        
        myURL = URL(string: "https://crm.mcgroup.pl")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
//    TEST DEL
    func startPrinting() {
            
        //        pdfView.print(with: printInfo, autoRotate: true)
        //        pdfView.print(with: printInfo, autoRotate: false)
    }
    
    @objc func printSomething(){
        print("print????")
        
        let pdfView = PDFView()
        let path = URL(string: "https://crm.mcgroup.pl/storage/app/public/Zus/ZUS-20221207114812.pdf")
        let pdfDoc = PDFDocument(url: path!)
        let wnd = NSWindow()

        pdfView.autoScales = true
        pdfView.delegate = self
        pdfView.displayMode = .twoUp
        pdfView.displayDirection = .horizontal
        pdfView.document = pdfDoc
        wnd.contentView = pdfView
        pdfView.print(with: NSPrintInfo.shared, autoRotate: true)
//           let printInfo = NSPrintInfo()
//           printInfo.topMargin = 0
//           printInfo.leftMargin = 0
//           printInfo.bottomMargin = 0
//           printInfo.rightMargin = 0
//
//        let printOperation = NSPrintOperation(view: webView, printInfo: printInfo)
//           printOperation.run()
    
//        print("btn")
//        let operation = webView.printOperation(with: printInfo)
//        operation.view?.frame = webView.bounds
//
//        guard let window = webView.window else { return }
//        //        let newPrintOp = NSPrintOperation(view: webView, printInfo: self.printInfo)
//        operation.runModal(for: window, delegate: nil, didRun: nil, contextInfo: nil)
//
    }

    
//    TEST DEL
    
    
    
    
    
// control target blank link
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil {
            self.webView.load(navigationAction.request)
        }
        return nil
    }

    
//   for open upload files
    func webView(_ webView: WKWebView, runOpenPanelWith parameters: WKOpenPanelParameters, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping ([URL]?) -> Void) {
        print(frame)
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.begin { (result) in
            if result == NSApplication.ModalResponse.OK {
                if let url = openPanel.url {
                    completionHandler([url])
                }
            } else if result == NSApplication.ModalResponse.cancel {
                completionHandler(nil)
            }
        }
       
    }
    
    

   /*
    Download the file from the given url and store it locally in the app's temp folder.
    */

//    check downloading file
    func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
        let url = response.url
        DownlondFromUrl(sendDown: url!, fileName: suggestedFilename)
    }
    func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
        download.delegate = self
    }
        
    func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
        download.delegate = self
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        if navigationAction.shouldPerformDownload {
            decisionHandler(.download, preferences)
        } else {
            decisionHandler(.allow, preferences)
        }
    }

    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if navigationResponse.canShowMIMEType {
            decisionHandler(.allow)
        } else {
            decisionHandler(.download)
        }
    }
    
//    function downloadfile
    
    func DownlondFromUrl(sendDown:URL, fileName:String){
        let fileURL = sendDown
        let documentsUrl:URL =  (FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first as URL?)!
        let destinationFileUrl = documentsUrl.appendingPathComponent(fileName)

        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let request = URLRequest(url:fileURL)

        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }

                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                } catch (_) {
                    let random = Int(arc4random_uniform(11) + 1)
                    let newName = "\(random)_\(fileName)"
                    self.DownlondFromUrl(sendDown: fileURL, fileName: newName)
                    
                    print("Error creating a file \(destinationFileUrl) :")
                }

            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription as Any);
            }
        }
        task.resume()
    }
    
//    run script Page
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let config = WKPDFConfiguration()
        config.rect = CGRect(x: 0, y: 0, width: 792, height: 612)
        
        let compaire = URL(string: "https://crm.mcgroup.pl/login")
        if(webView.url == compaire){

            webView.evaluateJavaScript(setDataL, in: nil, in: .defaultClient) { result in
                    switch result {
                    case .success(_):
                            print("OK Run")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            webView.evaluateJavaScript(getDataL, in: nil, in: .defaultClient) { result in
                    switch result {
                    case .success(let response):
                            print("OK Run")
                            print("response \(response)")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
        }
    }
 
    
//  change title WKwebView
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            if let title = webView.title {
                self.view.window?.title = title
                self.view.window?.update()
            }
        }
        if let url = webView.url {
            print(url)
            myURL = webView.url
            print(myURL as Any)
        }
       
    }
    
    override var representedObject: Any? {
        didSet {
            
        }
    }
    
    
}

