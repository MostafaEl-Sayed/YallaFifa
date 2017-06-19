//
//  signinVC.swift
//  YallaFifa
//
//  Created by Ahmed Hussien on 6/10/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import UIKit

class SigninVC: GlobalController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollViewInitilaizer(scrollView: scrollView)
    }
    
    @IBAction func signinTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        RequestManager.defaultManager.signIn(email: emailTextField.text!, password: passwordTextField.text!) {(status, success) in
            if success {
                self.navigationController!.popViewController(animated: true)
            }
            else{
                self.navigationController!.presentAlert(title: "Error" , mssg: status)

            }
        }
    }
    
    
}
