//
//  Constants.swift
//  Mail
//
//  Created by A K on 11/9/19.
//  Copyright © 2019 AK. All rights reserved.
//

import UIKit

class Constants {

    static let imapHostName = "imap.laposte.net"
    static let imapPort: UInt32 = 993
    static let imapConnectionType: MCOConnectionType = .TLS
    
    static let smtpHostName = "smtp.laposte.net"
    static let smtpPort: UInt32 = 465
    static let smtpConnectionType: MCOConnectionType = .TLS
}
