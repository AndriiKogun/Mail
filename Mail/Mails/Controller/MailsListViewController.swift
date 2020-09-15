//
//  ViewController.swift
//  Mail
//
//  Created by A K on 10/31/19.
//  Copyright © 2019 AK. All rights reserved.
//

import UIKit
import SnapKit

class MailsListViewController: UIViewController {
    
    private let loadCount = 10
    
    private var messages = [MCOIMAPMessage]()
    private var folder = "INBOX"
    
    private var messagePreviews = [String: String]()

    private var imapMessagesFetchOpperation: MCOIMAPFetchMessagesOperation!
    private var imapCheckOperation: MCOIMAPOperation!
    private let imapSession = MCOIMAPSession()
    
    private var totalNumberOfInboxMessages: Int32 = -1
    private var isLoading = false
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MailTableViewCell.nib, forCellReuseIdentifier: MailTableViewCell.reuseIdentifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(sendAction))
        
        setupIMAP()
        setupLayout()
    }
    
    @objc func sendAction() {
        let vc = SendMailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    func setupIMAP() {
        let user = DataManager.shared.user()
        imapSession.hostname = Constants.imapHostName
        imapSession.port = Constants.imapPort
        imapSession.username = user?.email
        imapSession.password = user?.password
        imapSession.connectionType = Constants.imapConnectionType
        
        imapSession.connectionLogger = { (connectionID, type, data) in
            
        }

        let imapCheckOperation = imapSession.checkAccountOperation()
        imapCheckOperation?.start({ [weak self] (error) in
            guard let self = `self` else { return }
            if error == nil {
                self.loadMessages(self.loadCount)
            }
        })
    }
    
    func loadMessages(_ number: Int) {
        let number = Int32(number)
        let inboxFolderInfo = imapSession.folderInfoOperation(folder)
        isLoading = true
        
        inboxFolderInfo?.start({ [weak self] (error, info) in
            guard let self = `self` else { return }
            
            let totalNumberOfMessagesDidChange = self.totalNumberOfInboxMessages != info?.messageCount
            self.totalNumberOfInboxMessages = info?.messageCount ?? 0
                
            var numberOfMessagesToLoad = Int32(min(self.totalNumberOfInboxMessages, number))
            
            if numberOfMessagesToLoad == 0 {
                self.isLoading = false
                return
            }
            
            var fetchRange: MCORange!
            
            if !totalNumberOfMessagesDidChange && !self.messages.isEmpty {
                numberOfMessagesToLoad -= Int32(self.messages.count)
                fetchRange = MCORangeMake(UInt64(self.totalNumberOfInboxMessages - Int32(self.messages.count) - (numberOfMessagesToLoad - 1)), UInt64(numberOfMessagesToLoad - 1))
            } else {
                fetchRange = MCORangeMake(UInt64(self.totalNumberOfInboxMessages - (numberOfMessagesToLoad - 1)), UInt64(numberOfMessagesToLoad - 1))
            }
            
            self.imapMessagesFetchOpperation = self.imapSession.fetchMessagesByNumberOperation(withFolder: self.folder, requestKind: [.headers, .structure, .internalDate, .headerSubject, .flags], numbers: MCOIndexSet.init(range: fetchRange))
            self.imapMessagesFetchOpperation?.progress = { (current) in
                print("current\(current)")
            }
            
            self.imapMessagesFetchOpperation.start { (error, messages, vanishedMessages) in
                if let messages = messages as?  [MCOIMAPMessage] {
                    self.isLoading = false
                    self.messages.append(contentsOf: messages)
                    self.messages.sort(by: { $0.header.date > $1.header.date })
                    self.tableView.reloadData()
                }
            }
        })
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension MailsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MailTableViewCell.reuseIdentifier) as! MailTableViewCell
        cell.setupWith(message: message)
        
        
        let uidKey = String(message.uid)
        if let cachedPreview = messagePreviews[uidKey] {
            cell.messageLabel?.text = cachedPreview
        } else {
            cell.messageRenderingOperation = imapSession.plainTextBodyRenderingOperation(with: message, folder: folder)
            cell.messageRenderingOperation?.start({ [weak self] (plainTextBodyString, error) in
                guard let self = `self` else { return }
                cell.messageLabel.text = plainTextBodyString
                cell.messageRenderingOperation = nil
                self.messagePreviews[uidKey] = plainTextBodyString
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isLoading && messages.count < totalNumberOfInboxMessages && messages.count <= indexPath.row + 5 {
            loadMessages(messages.count + loadCount)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        let vc = MailDetailsViewController()
        vc.folder = "INBOX"
        vc.message = message
        vc.session = imapSession
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 60
//    }
}

