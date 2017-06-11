//
//  ViewController.swift
//  Banana
//
//  Created by Mostafa El_sayed on 5/17/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController , UIScrollViewDelegate {

    @IBOutlet weak var containerScrollView: UIScrollView!

    @IBOutlet weak var continueButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func backTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

