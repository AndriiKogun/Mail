//
//  SideMenuViewController.swift
//  Mail
//
//  Created by Andrii on 6/21/20.
//  Copyright © 2020 AK. All rights reserved.
//

import UIKit
import LGSideMenuController
import SnapKit

class SideMenuViewController: LGSideMenuController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        leftViewWidth = 220.0
        leftViewPresentationStyle = .slideAbove
        
        rightViewWidth = 180.0
        rightViewPresentationStyle = .slideAbove
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "burger_menu_icon"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(menuClick(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
    }
    
    private func setupLayout() {
//        var headerView: UIView
//
//        navigationController?.navigationBar.addSubview(headerView)
//        headerView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
    }
        
    @objc private func menuClick(_ sender: UIBarButtonItem) {
        showLeftViewAnimated()
    }
}
