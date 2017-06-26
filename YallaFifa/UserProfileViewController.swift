//
//  UserProfileViewController.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/20/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    
    @IBOutlet weak var requestGameBtn: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoneNumber: UILabel!
    var choosedMetpoint = Location()
    var userProfileData = User()
    var startRequesting = false
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareDataOfProfileView()
        
        
    }
    
    func prepareDataOfProfileView(){
        if startRequesting {
            self.requestGameBtn.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
