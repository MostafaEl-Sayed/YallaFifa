//
//  MatchDetailsVC.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/9/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import UIKit

class MatchDetailsVC: UIViewController,SSRadioButtonControllerDelegate {

    @IBOutlet weak var onlineMatchBtn: SSRadioButton!
    @IBOutlet weak var faceToFaceMatchBtn: SSRadioButton!
    
    // --------------------------
    var typeOfmatch:String?
    
    
    // --------------------------
    var radioButtonController:SSRadioButtonsController?
    override func viewDidLoad() {
        super.viewDidLoad()

        // register buttons to radioButtonController
        radioButtonController = SSRadioButtonsController(buttons: onlineMatchBtn,faceToFaceMatchBtn)
        
    }


    
    @IBAction func doneSelectionBtnAct(_ sender: Any) {
        
        if radioButtonController?.selectedButton() != nil {
            typeOfmatch = radioButtonController?.selectedButton()?.titleLabel?.text
        }else {
            self.displayMessage(title:"Error selection" , message: "Please enter type of match")
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

