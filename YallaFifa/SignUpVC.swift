//
//  ViewController.swift
//  Banana
//
//  Created by Mostafa El_sayed on 5/17/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpVC: GlobalController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        self.scrollViewInitilaizer(scrollView: scrollView)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }


    @IBAction func backTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func signupTapped(_ sender: Any) {
        
        if passwordTextField.text! != confirmPassTextField.text! {
            self.presentAlert(title: "Error" , mssg: "Confirm password field should be the same as password field!")
        }
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if let user = user {
                print("successfully signed up")
                self.ref.child("users").child(user.uid).setValue(["email": self.emailTextField.text! , "phoneNumber" :self.phoneNumberTextField.text!])
                self.ref.child("users").child(user.uid).child("location").setValue(["long" : "" , "lat" : ""])
                defaults.set("uid", forKey: user.uid)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "signin")
                self.present(vc!, animated: true, completion: nil)
                
            } else if let error = error {
                self.presentAlert(title: "Error" , mssg: error.localizedDescription)
            }
        }
    }
    
    
}

