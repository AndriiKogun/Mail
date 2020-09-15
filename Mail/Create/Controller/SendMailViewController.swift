//
//  SendMailViewController.swift
//  Mail
//
//  Created by A K on 11/9/19.
//  Copyright © 2019 AK. All rights reserved.
//

import UIKit
import WebKit

class SendMailViewController: UIViewController {
    
    var mailbox: String?
    
    @IBOutlet weak var sendToTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var webView: WKWebView!
    
    var html: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let mailbox = mailbox else { return }
        sendToTextField.text = mailbox
        
        guard let html = html else { return }
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        let user = DataManager.shared.user()

        let smtpSession = MCOSMTPSession()
        smtpSession.hostname = Constants.smtpHostName
        smtpSession.port = Constants.smtpPort
        smtpSession.username = user?.email
        smtpSession.password = user?.password
        smtpSession.authType = .saslPlain
        smtpSession.connectionType = Constants.smtpConnectionType
        
        
        let builder = MCOMessageBuilder()
        let from = MCOAddress(displayName: "Gamno", mailbox: user?.email)
        let to = MCOAddress(displayName: nil, mailbox: sendToTextField.text ?? "")

        builder.header.from = from
        builder.header.to = [to as Any]
        builder.header.subject = subjectTextField.text ?? ""
        builder.htmlBody = messageTextView.text
        let rfc822Data = builder.data()

        let sendOperation = smtpSession.sendOperation(with: rfc822Data)
        sendOperation?.start({ (error) in
            if let error = error {
                print("Error sending email" + error.localizedDescription)
            } else {
                print("Successfully sent email!")
            }
        })
    }
}
