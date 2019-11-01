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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = 40
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.register(SearchSuggestionTableViewCell.self, forCellReuseIdentifier: SearchSuggestionTableViewCell.reuseIdentifier)
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

        let imapCheckOperation = imapSession.checkAccountOperation()
        imapCheckOperation?.start({ [weak self] (error) in
            guard let self = `self` else { return }
            if error == nil {
                self.loadMessages()
            }
        })
    }
    
    func loadMessages() {
        let inboxFolder = "INBOX"
        let inboxFolderInfo = imapSession.folderInfoOperation(inboxFolder)

        inboxFolderInfo?.start({ (error, info) in
            
            let fetchRange = MCORangeMake(611, 620);
            self.imapMessagesFetchOpperation = self.imapSession.fetchMessagesOperation(withFolder: inboxFolder, requestKind: [.headers, .structure, .internalDate, .headerSubject, .flags], uids: MCOIndexSet.init(range: fetchRange))
            self.imapMessagesFetchOpperation?.progress = { (current) in
                print("current\(current)")
            }
            
            self.imapMessagesFetchOpperation.start { (error, messages, vanishedMessages) in
                if let messages = messages as?  [MCOIMAPMessage] {
                    self.messages = messages
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
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = message.header.subject
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

