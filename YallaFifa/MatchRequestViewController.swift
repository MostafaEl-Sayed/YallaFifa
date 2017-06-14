//
//  MakeDonationViewController.swift
//  Wasteless
//
//  Created by Mostafa El_sayed on 1/29/17.
//  Copyright © 2017 Industrial. All rights reserved.mm
//

import UIKit
import CoreLocation
import Foundation
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class MatchRequestViewController: UIViewController , CLLocationManagerDelegate , GMSMapViewDelegate  {

    
    var id = ""
    var typeOfDonation = "food" // “food”, “clothing
    var locationManager = CLLocationManager()
    
    
    @IBOutlet weak var mapView: GMSMapView!
    var chosedLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0,longitude: 0)
    var userCurrentLocation = [String : Double]()
    
    // --------------------------------
    var anotherLocation = false
    // --------------------------------
    @IBOutlet weak var locationLabel: UILabel!
    var locatonlabelValue = "Where should we pick up the donation ?"
    var counterChangeStatusOflocation = 0
    
    // --------------------------------
    @IBOutlet weak var addNewPsView: UIView!
    
    // --------------------------------
    @IBOutlet weak var chooseRandomlyView: UIView!
    @IBOutlet weak var chooseRandomlyBtn: UIButton!
    
    // --------------------------------
    var allOnlineUsers = [User]()
    var allPhysically = [User]()
    
    // --------------------------------
    var psChoosedLocation = [String : Double]()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Map setup
        
        self.mapView.delegate = self
        mapView.setMinZoom(10, maxZoom: 19)
        self.mapView.isMyLocationEnabled = true
        mapView.isIndoorEnabled = true
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        
        // dummy data 
        let onlineUser1 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.25506634),"lng":(29.96618978)],typeOfUser: "online")
        let onlineUser2 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.23506634),"lng":(29.96618978)],typeOfUser: "online")
        let onlineUser3 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.28506634),"lng":(29.96618978)],typeOfUser: "online")
        let onlineUser4 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.29506634),"lng":(29.96618978)],typeOfUser: "online"
        )
        
        let phyUser1 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.25506634),"lng":(29.9461897)],typeOfUser: "physically")
        let phyUser2 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.27506634),"lng":(29.93618978)],typeOfUser: "physically")
        let phyUser3 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.28506634),"lng":(29.96418978)],typeOfUser: "physically")
        let phyUser4 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.29506634),"lng":(29.96818978)],typeOfUser: "physically")
       
        allOnlineUsers = [onlineUser1,onlineUser2,onlineUser3,onlineUser4]
        allPhysically = [phyUser1,phyUser2,phyUser3,phyUser4]
        drowUsersLocationsMarkers(users: allOnlineUsers, imageMarkerName: "Joystick")
    }
   

    @IBAction func currentLocation(_ sender: Any) {
        anotherLocation = false
       
        
        let latitude  = self.locationManager.location?.coordinate.latitude
        let longitude = self.locationManager.location?.coordinate.longitude
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                
                   self.displayMessage(title: "Could not find your location", message: "Please allow YallaFifa to access your location from settings")
            case .authorizedAlways, .authorizedWhenInUse:
                let camera = GMSCameraPosition.camera(withLatitude: latitude!,longitude: longitude!, zoom: self.mapView.camera.zoom)
                UIView.animate(withDuration: 20.0, animations: {
                    self.mapView.camera = camera
                })
            }
        } else {
            
            
            self.displayMessage(title: "Could not find your location", message: "Please allow YallaFifa to access your location from settings")
        }
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let latitude  = self.locationManager.location?.coordinate.latitude
        let longitude = self.locationManager.location?.coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: latitude!,longitude: longitude!, zoom: 20)
        self.mapView.camera = camera
        //self.locationLabel.text! = "\(self.locatonlabelValue)"

        self.navigationController?.navigationBar.isHidden = true
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        //manager.stopUpdatingLocation()
        let camera = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!,longitude: (self.locationManager.location?.coordinate.longitude)!, zoom: 14)
        self.mapView.camera = camera
        let lat = userLocation.coordinate.latitude
        let long = userLocation.coordinate.longitude
        print("user latitude = \(lat)")
        print("user longitude = \(long)")
        
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        //let lat = position.target.latitude
        //let long = position.target.longitude
        psChoosedLocation = ["lat":(31.25506634), "lng":(29.9461897)]
    }
    func drowUsersLocationsMarkers(users:[User]?,imageMarkerName:String)  {
        // clear all old markers from the map
        mapView.clear()
        guard users != nil else {
            return
        }
        for user in users! {
            let lat = user.location["lat"]
            let long = user.location["lng"]
            let position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            let marker = GMSMarker(position: position)
            marker.title = user.name
            marker.icon = UIImage(named: imageMarkerName)
            marker.map = mapView
        }
    }
    @IBAction func addNewPsBtnAct(_ sender: Any) {
       
        
        
    }
    @IBAction func chooseRandomlyBtnAct(_ sender: Any) {
        
    }
    @IBAction func chooseAnotherLocationBtnAct(_ sender: Any) {
        self.counterChangeStatusOflocation = 0 
        let autocompletecontroller = GMSAutocompleteViewController()
        autocompletecontroller.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment  //suitable filter type
        filter.country = "EG"  //appropriate country code
        autocompletecontroller.autocompleteFilter = filter
        self.present(autocompletecontroller, animated: true, completion: nil)
    }
   
    @IBAction func segmentAct(_ sender:UISegmentedControl ) {
        
        if sender.selectedSegmentIndex == 0{ // Online Users
            drowUsersLocationsMarkers(users: allOnlineUsers,imageMarkerName: "Joystick")
            self.addNewPsView.isHidden = true
            
        }else {// Physical Users
            drowUsersLocationsMarkers(users: allPhysically,imageMarkerName: "Joystick")
            self.addNewPsView.isHidden = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    @IBAction func backBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddPhotoController" {
            
//            let destinationVC = segue.destination as! AddPhotoController
//            destinationVC.id = self.id
//            destinationVC.user = self.user
//            destinationVC.typeOfDonation = self.typeOfDonation
//            destinationVC.orderLocation = self.choosedLocationDic
            
        }
    }

   
}

extension MatchRequestViewController:   UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
extension MatchRequestViewController:  GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: ", place.name)
        self.chosedLocation = place.coordinate
        self.userCurrentLocation = [
            "lat":(self.chosedLocation.latitude) ,
            "lng":(self.chosedLocation.longitude)
        ]
        self.locatonlabelValue = place.name
        self.anotherLocation = true
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // To handle error
        print(error)
        
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}
