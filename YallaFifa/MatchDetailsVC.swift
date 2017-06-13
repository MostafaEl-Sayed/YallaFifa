//
//  MatchDetailsVC.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/9/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import UIKit

class MatchDetailsVC: UIViewController {

    
    @IBOutlet weak var onlineMatchLabel: UILabel!
    @IBOutlet weak var meetFriendsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    
    @IBAction func doneSelectionBtnAct(_ sender: UIButton) {
        
        if sender.tag == 0 {
            meetFriendsLabel.backgroundColor = UIColor.clear
            onlineMatchLabel.backgroundColor = UIColor(hex: "C6A128", alphaNum: 0.5)
        }else{
            onlineMatchLabel.backgroundColor = UIColor.clear
            meetFriendsLabel.backgroundColor = UIColor(hex: "C6A128", alphaNum: 0.5)
        }
        
    }
    
    @IBAction func goButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func signoutButtonTapped(_ sender: Any) {
        
    }

}

