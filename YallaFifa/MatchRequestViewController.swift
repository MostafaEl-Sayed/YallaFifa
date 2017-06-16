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
    // --------------------------------

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var getCurrentLocationBtn: UIButton!
    @IBOutlet weak var chooseLocationView: UIView!
    @IBOutlet weak var estimationTimeAndDistanceView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var menuView: UIView!
    
    var makeBackEnable = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Map setup
        self.userCurrentLocation = [
            "lat":(self.locationManager.location?.coordinate.latitude)! ,
            "lng":(self.locationManager.location?.coordinate.longitude)!
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
    @IBAction func returnBackSearchBtnAct(_ sender: Any) {
        if makeBackEnable {
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let translationValue = chooseLocationView.frame.size.width + menuView.frame.size.width - (0.1*screenWidth/2)
            let right = CGAffineTransform(translationX:translationValue ,y: 0)
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
                
                self.chooseLocationView.transform = right
            }, completion: nil)
            makeBackEnable = false

        }
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
    //    getDirections(origin: "\(31.25506634),\(29.96618978)", destination: "\(31.29506634),\(29.9461897)", waypoints: nil, travelMode: nil)
    // ----------------------------------------
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    var selectedRoute: NSDictionary!
    var overviewPolyline: NSDictionary!
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    var originAddress: String!
    var destinationAddress: String!
    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    var routePolyline: GMSPolyline!
    var oneRootadded = false
    var prevMarkerPosition:CLLocationCoordinate2D!
    // -------------------------------------------
    var totalDistanceInMeters: UInt = 0
    var totalDistance: String!
    var totalDurationInSeconds: UInt = 0
    var totalDuration: String!
        func createBlueLineBetween2locations(orderedLatLong startPoint :String,endPoints:String){
            
            let orgin = startPoint
            let destination = endPoints
            getDirections(origin: orgin, destination: destination, waypoints: nil, travelMode: nil, completionHandler: { (status, success) -> Void in
                if success {
                    self.drawRoute()
                    self.calculateTotalDistanceAndDuration()
                }
                else {
    
                }
            })
    
        }
    // Network Layer
    

    func getDirections(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: @escaping ((_ status:   String, _ success: Bool) -> Void)) {
        if let originLocation = origin {
            if let destinationLocation = destination {
                var directionsURLString = baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation
                
                directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                
                let defaultSession = URLSession(configuration: .default)
                let url = URL(string: directionsURLString)!
                let task = defaultSession.dataTask(with: url) { data, response, error in
                    
                    
                    if let error = error {
                        print("DataTask error: " + error.localizedDescription + "\n")
                    } else if let data = data,
                        let response = response as? HTTPURLResponse,
                        response.statusCode == 200 {
                        
                        //let status = data["status"] as! String
                        do {
                            if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                                
                                let status = dictionary["status"] as! String
                                print(status)
                                if status == "OK" {
                                    self.selectedRoute = (dictionary["routes"] as! [[NSObject:AnyObject]])[0] as NSDictionary
                                    self.overviewPolyline = self.selectedRoute["overview_polyline"] as! NSDictionary
                                
                                    let legs = self.selectedRoute["legs"] as! [NSDictionary]
                                    let startLocationDictionary = legs[0]["start_location"] as! NSDictionary
                                    self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                                    let endLocationDictionary = legs[legs.count - 1]["end_location"] as! NSDictionary
                                    self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                                    
                                    self.originAddress = legs[0]["start_address"] as! String
                                    self.destinationAddress = legs[legs.count - 1]["end_address"] as! String
                                completionHandler(status, true)
                                }   else {
                                completionHandler(status, false)
                            }
                                
                                
                            }
                            
                        }catch let error as NSError {
                            print(error.localizedDescription)
                            completionHandler("", false)
                        }
                        
                    }
                }
                task.resume()
            }
        }
    }
    
        func drawRoute() {
            let route = overviewPolyline["points"] as! String
            let path: GMSPath = GMSPath(fromEncodedPath: route)!
            routePolyline = GMSPolyline(path: path)
            routePolyline.strokeWidth = 2
            routePolyline.map = self.mapView
            oneRootadded = true
//            self.distanceLabel.text! = "\(totalDistanceInMeters/1000)km"
//            self.timeLabel.text! = "\(totalDurationInSeconds/60)mins"
//            self.timeLabel.setValue("\(totalDurationInSeconds/60)mins", forKey: "\(totalDurationInSeconds/60)mins")
            
            
        }
    func calculateTotalDistanceAndDuration() {
        
        let legs = self.selectedRoute["legs"] as! [NSDictionary]
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
        let right = CGAffineTransform(translationX:translationValue ,y: 0)
       
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.estimationTimeAndDistanceView.transform = right
        }, completion: nil)

    }
    func startAnimatingViews() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let translationValue = -chooseLocationView.frame.size.width + menuView.frame.size.width - (0.1*screenWidth/2)
        let left = CGAffineTransform(translationX:translationValue ,y: 0)
        let top = CGAffineTransform(translationX: 0, y: -300)
        
        let down = CGAffineTransform(translationX: 0, y: addNewPsView.frame.size.height)
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            // Add the transformation in this block
            // self.container is your view that you want to animate
            self.addNewPsView
                .transform = down
            self.getCurrentLocationBtn.transform = down
            self.chooseRandomlyView.transform = down
            self.chooseLocationView.transform = left
        }, completion: nil)
        self.chooseRandomlyBtn.setTitle("Confirm Request", for: .normal)
        makeBackEnable = true
        
        
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        startAnimatingViews()
        
        if oneRootadded && prevMarkerPosition.latitude == marker.position.latitude && prevMarkerPosition.longitude == marker.position.longitude{
            
            return false
            
        }
        if oneRootadded {
            routePolyline.map = nil
        }
        
        createBlueLineBetween2locations(orderedLatLong: "\(userCurrentLocation["lat"]!),\(userCurrentLocation["lng"]!)", endPoints: "\(marker.position.latitude),\(marker.position.longitude)")
        prevMarkerPosition = marker.position
        return true
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
