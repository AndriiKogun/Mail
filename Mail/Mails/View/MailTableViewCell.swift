//
//  MailTableViewCell.swift
//  Mail
//
//  Created by A K on 11/4/19.
//  Copyright © 2019 AK. All rights reserved.
//

import UIKit

class MailTableViewCell: UITableViewCell {
    
    var messageRenderingOperation: MCOIMAPMessageRenderingOperation?
    
    func setupWith(message: MCOIMAPMessage) {
        senderIconLabel.text = String(message.header.sender.displayName?.first ?? Character(" "))
        senderLabel.text = message.header.sender.displayName
        titleLabel.text = message.header.subject
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateLabel.text = dateFormatter.string(from: message.header.date)
    }

    @IBOutlet private weak var senderIconLabel: UILabel!
    @IBOutlet private weak var senderLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        messageRenderingOperation?.cancel()
        messageLabel.text = ""
    }
}
