//
//  MailTableViewCell.swift
//  Mail
//
//  Created by A K on 11/4/19.
//  Copyright © 2019 AK. All rights reserved.
//

import UIKit

class MailTableViewCell: UITableViewCell {
    
    func setupWith(message: MCOIMAPMessage) {
        senderIconLabel.text = String(message.header.sender.displayName?.first ?? Character(""))
        senderLabel.text = message.header.sender.displayName
        titleLabel.text = message.header.subject
        messageLabel.text = "Test"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateLabel.text = dateFormatter.string(from: message.header.date)
    }

    @IBOutlet private weak var senderIconLabel: UILabel!
    @IBOutlet private weak var senderLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
