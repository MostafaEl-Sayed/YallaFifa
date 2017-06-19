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
    var chosedLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 30,longitude: 30)
    var userCurrentLocation = [String : Double]()
    var anotherLocation = false
    var locatonlabelValue = "Where should we pick up the donation ?"
    var counterChangeStatusOflocation = 0
    var allOnlineUsers = [User]()
    var allPhysically = [User]()
    var psChoosedLocation = [String : Double]()
    var makeBackEnable = false
    var choosedMetpoint = [String : Double]()
    var newPSStatusActive = false
    var startChooseMeetingPointStatus = false
    // --------------------------------
    @IBOutlet weak var chooseMeetingPointLabel: UILabel!
    @IBOutlet weak var locationLogoImg: UIImageView!
    @IBOutlet weak var choosePointToMeetFriendLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var getCurrentLocationBtn: UIButton!
    @IBOutlet weak var chooseLocationView: UIView!
    @IBOutlet weak var estimationTimeAndDistanceView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var cancelRequestBtn: UIButton!
    @IBOutlet weak var searchViewBtn: UIButton!
    @IBOutlet weak var smallSearchBtn: UIButton!
    @IBOutlet weak var chooseRandomlyView: UIView!
    @IBOutlet weak var chooseRandomlyBtn: UIButton!
    @IBOutlet weak var addNewPsView: UIView!
    
    @IBOutlet weak var chooseMeetingPointLocationView: UIView!
    @IBOutlet weak var chooseMeetingPointView: UIView!
    
    @IBOutlet weak var flipViewControllerBtn: UIButton!
    @IBOutlet weak var fliveViewControllerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Map setupx
        let latitude  = self.locationManager.location?.coordinate.latitude
        let longitude = self.locationManager.location?.coordinate.longitude
        
        self.userCurrentLocation = [
            "lat":latitude! ,
            "lng":longitude!
        ]
        
        self.mapView.delegate = self
        mapView.setMinZoom(10, maxZoom: 19)
        self.mapView.isMyLocationEnabled = true
        mapView.isIndoorEnabled = true
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        
        // dummy data 
        let onlineUser1 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.25506634),"lng":(29.97618978)],typeOfUser: "online")
        let onlineUser2 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.23506634),"lng":(29.97618978)],typeOfUser: "online")
        let onlineUser3 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.28506634),"lng":(29.97618978)],typeOfUser: "online")
        let onlineUser4 = User(name: "Ahmed", phone: "011411", address: "", location: ["lat":(31.29506634),"lng":(29.97618978)],typeOfUser: "online"
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
       
        locationLabel.text! = "Current location"
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
        if anotherLocation {
            let camera = GMSCameraPosition.camera(withLatitude:chosedLocation.latitude,longitude: chosedLocation.longitude, zoom: self.mapView.camera.zoom)
            self.mapView.camera = camera
            self.locationLabel.text! = "\(self.locatonlabelValue)"
        }
        self.navigationController?.navigationBar.isHidden = true
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        let camera = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!,longitude: (self.locationManager.location?.coordinate.longitude)!, zoom: 14)
        self.mapView.camera = camera
        
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let lat = position.target.latitude
        let long = position.target.longitude
        choosedMetpoint = [
            "lat":lat ,
            "lng":long
        ]
        if startChooseMeetingPointStatus {
            animateViewsWhileSelectingMeetPoint()
            startChooseMeetingPointStatus = false
        }
        
//        UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
//            self.chooseLocationView.alpha = 0.0
//        }, completion: nil)
        
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let defaultValue = CGAffineTransform(translationX: 0, y:0)
        
        UIView.animate(withDuration: 0.5, animations: {
            
            
            self.addNewPsView.transform = defaultValue
            
            self.getCurrentLocationBtn.transform = defaultValue
            self.menuView.transform = defaultValue
            self.fliveViewControllerView.transform = defaultValue
        })
        self.chooseLocationView.isHidden = false
        self.estimationTimeAndDistanceView.isHidden = false
    }
    func animateViewsWhileSelectingMeetPoint()  {
        let down = CGAffineTransform(translationX: 0, y: addNewPsView.frame.size.height)
        let top = CGAffineTransform(translationX: 0, y: -100)
        UIView.animate(withDuration: 0.5, animations: {
            
            self.chooseLocationView.alpha = 1.0
            self.addNewPsView.transform = down
            
            self.getCurrentLocationBtn.transform = down
            self.menuView.transform = top
            self.fliveViewControllerView.transform = top
        })
        self.chooseLocationView.isHidden = true
        self.estimationTimeAndDistanceView.isHidden = true
    }
    
    
    func mapViewDidStartTileRendering(_ mapView: GMSMapView) {
       animateViewsWhileSelectingMeetPoint()
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
    @IBAction func flipViewControllerBtnAct(_ sender: Any) {
        let  mainStory = UIStoryboard(name: "Main", bundle: nil)
        let search = mainStory.instantiateViewController(withIdentifier: "MatchRequestTableViewController") as! MatchRequestTableViewController
        UIView.beginAnimations("animation", context: nil)
        UIView.setAnimationDuration(1.0)
        self.navigationController!.pushViewController(search, animated: false)
        UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self.navigationController!.view, cache: false)
        UIView.commitAnimations()
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
    @IBAction func returnBackSearchBtnAct(_ sender: Any) {
        if makeBackEnable {
            searchViewBtn.isEnabled = true
            let defaultValue = CGAffineTransform(translationX:0 ,y: 0)
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
                self.chooseLocationView.transform = defaultValue
                self.chooseMeetingPointView.transform = defaultValue
                self.smallSearchBtn.setImage(UIImage(named:"Search"), for: .normal)
            }, completion: nil)
            makeBackEnable = false

        }
    }
    
    @IBAction func backBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelRequestBtnAct(_ sender: Any) {
        self.blueLine.routePolyline.map = nil

        
        let defaultValue = CGAffineTransform(translationX:0 ,y: 0)
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.addNewPsView.transform = defaultValue
            self.cancelRequestBtn.transform = defaultValue
            self.chooseLocationView.transform = defaultValue
            self.chooseMeetingPointView.transform = defaultValue
            self.estimationTimeAndDistanceView.transform = defaultValue
            self.flipViewControllerBtn.transform = defaultValue
        }, completion: { (finished: Bool) in
           self.fliveViewControllerView.isHidden = false
        }
        )
        
        self.smallSearchBtn.setImage(UIImage(named:"Search"), for: .normal)
        makeBackEnable = true
        searchViewBtn.isEnabled = true
        choosePointToMeetFriendLabel.isHidden = true
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
    //    getDirections(origin: "\(31.25506634),\(29.96618978)", destination: "\(31.29506634),\(29.9461897)", waypoints: nil, travelMode: nil)
    // ----------------------------------------
    var oneRootadded = false
    var prevMarkerPosition:CLLocationCoordinate2D!
    var blueLine:BlueLine!
    // -------------------------------------------
    var totalDistanceInMeters: UInt = 0
    var totalDistance: String!
    var totalDurationInSeconds: UInt = 0
    var totalDuration: String!
        func createBlueLineBetween2locations(orderedLatLong startPoint :String,endPoints:String){
            
            let orgin = startPoint
            let destination = endPoints
            RequestManager.defaultManager.getDirections(origin: orgin, destination: destination, completionHandler: { (status, success , data) -> Void in
                if success {
                    self.blueLine = data
                    self.drawRoute()
                    self.calculateTotalDistanceAndDuration()
                }
                else {
                    self.displayMessage(title: "Request Field", message: "Bad internet connection")
    
                }
            })
    
        }
    // Network Layer
    

    
    func drawRoute() {
            let route = blueLine.overviewPolyline["points"] as! String
            let path: GMSPath = GMSPath(fromEncodedPath: route)!
            blueLine.routePolyline = GMSPolyline(path: path)
            blueLine.routePolyline.strokeWidth = 2
            blueLine.routePolyline.map = self.mapView
            oneRootadded = true
//            self.distanceLabel.text! = "\(totalDistanceInMeters/1000)km"
//            self.timeLabel.text! = "\(totalDurationInSeconds/60)mins"
//            self.timeLabel.setValue("\(totalDurationInSeconds/60)mins", forKey: "\(totalDurationInSeconds/60)mins")
            
            
        }
    func calculateTotalDistanceAndDuration() {
        
        let legs:[NSDictionary] = self.blueLine.selectedRoute.getValueForKey(Key: "legs", callBack: [])
        totalDistanceInMeters = 0
        totalDurationInSeconds = 0
        
        for leg in legs {
            totalDistanceInMeters += (leg["distance"] as! NSDictionary)["value"] as! UInt
            totalDurationInSeconds += (leg["duration"] as! NSDictionary)["value"] as! UInt
        }
        
        let distanceInKilometers: Double = Double(totalDistanceInMeters / 1000)
        totalDistance = "Total Distance: \(distanceInKilometers) Km"
        self.distanceLabel.text! = "\(distanceInKilometers) Km"
        
        let mins = totalDurationInSeconds / 60
        let hours = mins / 60
        let days = hours / 24
        let remainingHours = hours % 24
        let remainingMins = mins % 60
        let remainingSecs = totalDurationInSeconds % 60
        
        totalDuration = "Duration: \(days) d, \(remainingHours) h, \(remainingMins) mins, \(remainingSecs) secs"
        self.timeLabel.text! = "\(remainingMins) mins"
        print("bagy oksim bllah")
        let translationValue = estimationTimeAndDistanceView.frame.size.width - menuView.frame.size.width
        let left = CGAffineTransform(translationX:-translationValue ,y: 0)
        self.fliveViewControllerView.isHidden = true
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.estimationTimeAndDistanceView.transform = left
        }, completion: nil)
        

    }
    
    func startAnimatingViews() {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let translationValue = -chooseLocationView.frame.size.width + menuView.frame.size.width - (0.1*screenWidth/2)
        
        let left = CGAffineTransform(translationX:translationValue ,y: 0)
        let top = CGAffineTransform(translationX: 0, y: -addNewPsView.frame.size.height + 8)
        let down = CGAffineTransform(translationX: 0, y: addNewPsView.frame.size.height)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            
            self.addNewPsView.transform = down
            self.cancelRequestBtn.transform = top
            self.chooseLocationView.transform = left
            self.chooseMeetingPointView.transform = left
            self.flipViewControllerBtn.transform = top
    
        }, completion: nil)
        //chooseRandomlyBtn.isEnabled = false
        locationLogoImg.isHidden = false
        //choosePointToMeetFriendLabel.isHidden = false
        //self.chooseRandomlyBtn.setTitle("Confirm Request", for: .normal)
        self.smallSearchBtn.setImage(UIImage(named:"RightLongArrow"), for: .normal)
        makeBackEnable = true
        searchViewBtn.isEnabled = false
        flipViewControllerBtn.isHidden = true
       
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        startAnimatingViews()
        chooseMeetingPointLabel.text! = "Choose Meeting Point"
        newPSStatusActive = false
        if oneRootadded && prevMarkerPosition.latitude == marker.position.latitude && prevMarkerPosition.longitude == marker.position.longitude{
            return false
        }
        if oneRootadded {
            blueLine.routePolyline.map = nil
        }
        
        createBlueLineBetween2locations(orderedLatLong: "\(userCurrentLocation["lat"]!),\(userCurrentLocation["lng"]!)", endPoints: "\(marker.position.latitude),\(marker.position.longitude)")
        prevMarkerPosition = marker.position
        return true
    }
    
    @IBAction func searchViewBtnAct(_ sender: Any) {
        self.counterChangeStatusOflocation = 0
        let autocompletecontroller = GMSAutocompleteViewController()
        autocompletecontroller.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment  //suitable filter type
        filter.country = "EG"  //appropriate country code
        autocompletecontroller.autocompleteFilter = filter
        self.present(autocompletecontroller, animated: true, completion: nil)
        
    }
    @IBAction func addNewPSLocationBtnAct(_ sender: Any) {
        
        chooseMeetingPointLabel.text! = "Choose Play Station Point"
        newPSStatusActive = true
    }
    
   
}

extension MatchRequestViewController:   UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognixzer: UIGestureRecognizer) -> Bool {
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