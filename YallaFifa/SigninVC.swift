//
//  signinVC.swift
//  YallaFifa
//
//  Created by Ahmed Hussien on 6/10/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SigninVC: GlobalController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        self.scrollViewInitilaizer(scrollView: scrollView)
    }
    
    @IBAction func signinTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if let user = user {
                let uid = user.uid
                let defaults = UserDefaults.standard
                defaults.set("uid", forKey: uid)
                print("Good")
                self.view.endEditing(true)
            }
            if let error = error {
                self.presentAlert(title: "Error" , mssg: error.localizedDescription)
            }
        }

    }
}
