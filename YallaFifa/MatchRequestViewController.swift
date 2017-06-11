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
    var choosedLocationDic = [String : Double]()
    
    // --------------------------------
    var locatiionStatus = false
    var anotherLocation = false
    // --------------------------------
    @IBOutlet weak var locationLabel: UILabel!
    var locatonlabelValue = "Where should we pick up the donation ?"
    var counterChangeStatusOflocation = 0
    
    // --------------------------------
    @IBOutlet weak var addNewPsView: UIView!
    
    // --------------------------------
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var chooseRandomlyView: UIView!
    @IBOutlet weak var chooseRandomlyBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        print("viewDidLoad")
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        if  locatiionStatus {
              let camera = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!,longitude: (self.locationManager.location?.coordinate.longitude)!, zoom: 14)
            self.mapView.camera = camera

            
        }
    
        mapView.setMinZoom(10, maxZoom: 19)
        self.mapView.isMyLocationEnabled = true
        mapView.isIndoorEnabled = true
        
        
        
        print("\(typeOfDonation) id , DonationsController")
        
    }
   
    @IBAction func currentLocation(_ sender: Any) {
        anotherLocation = false
       
        
        let latitude  = self.locationManager.location?.coordinate.latitude
        let longitude = self.locationManager.location?.coordinate.longitude
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                
                   self.displayMessage(title: "Could not find your location", message: "Please allow Wasteless Egypt to access your location from settings")
            case .authorizedAlways, .authorizedWhenInUse:
                let camera = GMSCameraPosition.camera(withLatitude: latitude!,longitude: longitude!, zoom: self.mapView.camera.zoom)
                UIView.animate(withDuration: 20.0, animations: {
                    self.mapView.camera = camera
                })
            }
        } else {
            
            
            self.displayMessage(title: "Could not find your location", message: "Please allow Wasteless Egypt to access your location from settings")
        }
//
        
       
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        if anotherLocation {
            let camera = GMSCameraPosition.camera(withLatitude:chosedLocation.latitude,longitude: chosedLocation.longitude, zoom: self.mapView.camera.zoom)
            self.mapView.camera = camera
            self.locationLabel.text! = "\(self.locatonlabelValue)"
        }else{
            determineMyCurrentLocation()
        }
        
        
            
        
        self.navigationController?.navigationBar.isHidden = true
    }

    func determineMyCurrentLocation() -> Bool{
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            self.mapView?.isMyLocationEnabled = true
            //locationManager.startUpdatingHeading()
            return true
        }else {
            return false
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        locatiionStatus = true
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        manager.stopUpdatingLocation()
        let camera = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!,longitude: (self.locationManager.location?.coordinate.longitude)!, zoom: 14)
        self.mapView.camera = camera
        let lat = userLocation.coordinate.latitude
        let long = userLocation.coordinate.longitude
        print("user latitude = \(lat)")
        print("user longitude = \(long)")
        
        
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
        if sender.selectedSegmentIndex == 0{
            self.addNewPsView.isHidden = true
        }else {
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
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.chosedLocation = position.target
        self.choosedLocationDic = [
            "lat":(self.chosedLocation.latitude) ,
            "lng":(self.chosedLocation.longitude)
        ]
        self.counterChangeStatusOflocation += 1
        
        if counterChangeStatusOflocation == 4 {
            
            self.locationLabel.text! = "Where should we pick up the donation ?"
        }
        
        
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
        self.choosedLocationDic = [
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
    
    func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }


    
}
