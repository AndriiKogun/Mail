//
//  WebViewController.swift
//  LiveExpert
//
//  Created by A K on 11/16/19.
//  Copyright © 2019 Victor Amelin. All rights reserved.
//

import UIKit
import WebKit

class MailDetailsViewController: UIViewController {
    
    var folder: String!
    var session: MCOIMAPSession!
    var message: MCOIMAPMessage!
    
    var test = ""
    
    private lazy var webView: WKWebView = {
        let viewportScriptString = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); meta.setAttribute('initial-scale', '1.0'); meta.setAttribute('maximum-scale', '1.0'); meta.setAttribute('minimum-scale', '1.0'); meta.setAttribute('user-scalable', 'no'); document.getElementsByTagName('head')[0].appendChild(meta);"
        
        let viewportScript = WKUserScript(source: viewportScriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let controller = WKUserContentController()
        controller.addUserScript(viewportScript)
        let config = WKWebViewConfiguration()
        config.userContentController = controller
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self;
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(sendAction))

        
        setupLayout()
        
        let op = session.fetchMessageOperation(withFolder: folder, uid: message.uid)
        op?.start({ (error, data) in
            let msg = MCOMessageParser(data: data)
            
            let content = msg?.htmlRendering(with: self)

            self.webView.loadHTMLString(self.test, baseURL: nil)
        })
    }
    
    private func setupLayout() {
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    @objc func sendAction() {
        let vc = SendMailViewController()
        vc.mailbox = message.header.from.mailbox
        vc.html = test
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MailDetailsViewController: MCOHTMLRendererIMAPDelegate {
    func mcoAbstractMessage(_ msg: MCOAbstractMessage!, dataFor part: MCOIMAPPart!, folder: String!) -> Data! {
        guard let attachment = message.part(forUniqueID: part.uniqueID) as? MCOAttachment else { return Data() }
        return attachment.data
    }
    
    func mcoAbstractMessage(_ msg: MCOAbstractMessage!, filterHTMLForPart html: String!) -> String! {
        test = html
        return html
    }
}

extension MailDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }

    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: ((WKNavigationActionPolicy) -> Void)) {
        guard let url = navigationAction.request.mainDocumentURL else { return }

        //"mailto:support@kabanchik.ua" - add in the future
        
        if url.absoluteString.contains("http") {
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
