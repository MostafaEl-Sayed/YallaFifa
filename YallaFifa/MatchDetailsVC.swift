//
//  MatchDetailsVC.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/9/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MatchDetailsViewContoller: UIViewController, CLLocationManagerDelegate  {

    
    @IBOutlet weak var onlineMatchLabel: UILabel!
    @IBOutlet weak var meetFriendsLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var userCurrentLocation = [String : Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(determineMyCurrentLocation())
    }

    
    @IBAction func doneSelectionBtnAct(_ sender: UIButton) {
        
        if sender.tag == 0 {
            meetFriendsLabel.backgroundColor = UIColor.clear
            onlineMatchLabel.backgroundColor = UIColor(hex: "C6A128", alphaNum: 0.5)
            userType = .onlineMatch
        }else{
            onlineMatchLabel.backgroundColor = UIColor.clear
            meetFriendsLabel.backgroundColor = UIColor(hex: "C6A128", alphaNum: 0.5)
            userType = .meetFriends
        }
        
    }
    
    func determineMyCurrentLocation() -> Bool{
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            return true
        }else {
            return false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
 
        manager.stopUpdatingLocation()
        let lat = userLocation.coordinate.latitude
        let long = userLocation.coordinate.longitude
        self.userCurrentLocation = [
            "lat":(lat) ,
            "lng":(long)
        ]
    }
    
    @IBAction func goButtonTapped(_ sender: Any) {
        if userType == .undefined {
            presentAlert(title: "", mssg: "You should selecet one of this choices")
            return
        }
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MatchRequestViewController") as! MatchRequestViewController
        vc.userCurrentLocation = self.userCurrentLocation
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func signoutButtonTapped(_ sender: Any) {
        defaults.set("uid", forKey: "")
        do{
            try Auth.auth().signOut()
            self.navigationController!.dismiss(animated: true, completion: nil)
        }
        catch let error as NSError{
            presentAlert(title: "", mssg: error.localizedDescription)
        }
    }

}

