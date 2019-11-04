//
//  ViewController.swift
//  Mail
//
//  Created by A K on 10/31/19.
//  Copyright © 2019 AK. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private var messages = [MCOIMAPMessage]()
    
//    @property (nonatomic, strong) MCOIMAPOperation *imapCheckOp;

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
        setupIMAP()
        setupLayout()
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
        imapSession.hostname = "imap.laposte.net"
        imapSession.port = 993
        imapSession.username = "gamnoposte@laposte.net"
        imapSession.password = "Piska2016"
        imapSession.connectionType = .TLS
        
        imapSession.connectionLogger = { (connectionID, type, data) in
            
        }

        let imapCheckOperation = imapSession.checkAccountOperation()
        imapCheckOperation?.start({ [weak self] (error) in
            guard let self = `self` else { return }
            if error == nil {
                self.loadMessages(10)
            }
        })
    }
    
    func loadMessages(_ number: Int32) {
        let inboxFolder = "INBOX"
        let inboxFolderInfo = imapSession.folderInfoOperation(inboxFolder)

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
            
            self.imapMessagesFetchOpperation = self.imapSession.fetchMessagesByNumberOperation(withFolder: inboxFolder, requestKind: [.headers, .structure, .internalDate, .headerSubject, .flags], numbers: MCOIndexSet.init(range: fetchRange))
            self.imapMessagesFetchOpperation?.progress = { (current) in
                print("current\(current)")
            }
            
            self.imapMessagesFetchOpperation.start { (error, messages, vanishedMessages) in
                if let messages = messages as?  [MCOIMAPMessage] {
                    self.messages = messages.sorted(by: { $0.header.date > $1.header.date })
                    self.tableView.reloadData()
                }
            }
        })
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MailTableViewCell.reuseIdentifier) as! MailTableViewCell
        cell.setupWith(message: message)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 60
//    }
}

