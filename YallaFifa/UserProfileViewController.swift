//
//  UserProfileViewController.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/20/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var callImgLogo: UIImageView!
    
    @IBOutlet weak var smallLine: UIView!
    @IBOutlet weak var callImgBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var requestGameBtn: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoneNumber: UILabel!
    @IBOutlet weak var notificationResponseView: UIView!
    var choosedMetpoint = Location()
    var userProfileData = User()
    var startRequesting = false
    
    var notificationComeProfileStatus = false
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareDataOfProfileView()
        if notificationComeProfileStatus {
            prepareStatusOfNotificationView()
        }
        
    }
    func prepareStatusOfNotificationView(){
        self.requestGameBtn.isHidden = true
        self.notificationResponseView.isHidden = false
        self.backBtn.isHidden = true
        userNameLabel.text! = userProfileData.email
        userPhoneNumber.text! = userProfileData.phone
    
    }
    
    func prepareDataOfProfileView(){
        if startRequesting {
            self.requestGameBtn.isHidden = false
        }else {
            callImgBtn.isHidden = true
            callImgLogo.isHidden = true
            smallLine.isHidden = true
        }
        userNameLabel.text! = userProfileData.email
        userPhoneNumber.text! = userProfileData.phone
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func startRequestingBtnAct(_ sender: Any) {
        print("player ID \(userProfileData.playerID)")
        RequestManager.defaultManager.sendRequestToUser(userProfileData,notificationMessage: "Yalla Bena nl3boo ya zmerro",notificationStatus: "newRequest") { (_, _) in
            print("am sent")
        }
    }
    @IBAction func acceptNotificationVtnAct(_ sender: Any) {
        print("curranto\(currentUser.playerID)")
        RequestManager.defaultManager.sendRequestToUser(currentUser,notificationMessage: "Ana bees ya 8ali",notificationStatus: "accept") { (_, _) in
            
        }
    }
    @IBAction func cancelNotificationBtnAct(_ sender: Any) {
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "matchDetailsNav") as! UINavigationController
        RequestManager.defaultManager.loadCurrentUser()
        appDelegate.window?.rootViewController = navigationController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func backBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
