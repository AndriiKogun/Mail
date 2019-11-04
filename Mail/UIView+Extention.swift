//
//  UIView+Extention.swift
//  Mail
//
//  Created by A K on 11/4/19.
//  Copyright © 2019 AK. All rights reserved.
//

import UIKit

extension UIView {
    
    class var reuseIdentifier: String {
        set {}
        
        get {
            return String(describing: self)
        }
    }
    
    class var nib: UINib {
        set {}
        
        get {
            return UINib(nibName: String(describing: self), bundle: nil)
        }
    }
}
