//
//  LoginViewController.swift
//  Mail
//
//  Created by A K on 11/9/19.
//  Copyright © 2019 AK. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func loginAction(_ sender: UIButton) {
        DataManager.shared.saveUser(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        
        let vc = MailsListViewController()
        let nc = UINavigationController(rootViewController: vc)
        
        let appDelegate = view.window?.windowScene?.delegate as? SceneDelegate
        let window = appDelegate?.window
        window?.rootViewController = nc
    }
}
