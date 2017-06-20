//
//  RequestManager.swift
//  Future Center
//
//  Created by MsZ on 8/23/16.
//  Copyright © 2016 MsZ. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RequestManager{
    
    var ref: DatabaseReference!
    
    static let defaultManager = RequestManager()
    private init (){
        print("* my private init *")
        self.ref = Database.database().reference()
    }
    
    func getDirections(origin: String!, destination: String!, completionHandler: @escaping ((_ status:   String, _ success: Bool,_ blueline: BlueLine?) -> Void)) {
        let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
        if let originLocation = origin {
            if let destinationLocation = destination {
                
                var directionsURLString = baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation
                
                directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                
                let defaultSession = URLSession(configuration: .default)
                let url = URL(string: directionsURLString)!
                let task = defaultSession.dataTask(with: url) { data, response, error in
                    
                    
                    if let error = error {
                        print("DataTask error: " + error.localizedDescription + "\n")
                        completionHandler("\(error.localizedDescription)", false, nil)
                    } else if let data = data,
                        let response = response as? HTTPURLResponse,
                        response.statusCode == 200 {
                        DispatchQueue.main.async {
                            do {
                        
                                if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                                    
                                    let status = dictionary["status"] as! String
                                    print(status)
                                    if status == "OK" {
                                        let convetedData = BlueLine(blueLineData: dictionary)
                                        completionHandler(status, true,convetedData)
                                    }   else {
                                        completionHandler(status, false , nil)
                                    }
                                    
                                    
                                }
                                
                            }catch let error as NSError {
                                print(error.localizedDescription)
                                completionHandler("", false , nil)
                            }
                        }
                        
                    }
                }
                task.resume()
            }
        }
    }
    
    func signIn(email : String , password : String , completionHandler:@escaping (_ status:   String, _ success: Bool) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let user = user {
                let uidd = "\(user.uid)"
            
                let defaults = UserDefaults.standard
                defaults.setValue("\(uidd)", forKey: "uid")
    
                
                completionHandler("Succefuly signin" , true)
            }
            if let error = error {
                completionHandler(error.localizedDescription , false)
            }
        }
    }
    
    func sigup(email : String , password : String , phoneNumber : String , completionHandler:@escaping (_ status:   String, _ success: Bool) -> Void){
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let user = user {
                print("successfully signed up")
                self.ref.child("users").child(user.uid).setValue(["email": email , "phoneNumber" : phoneNumber ])
                self.ref.child("users").child(user.uid).child("location").setValue(["long" : "" , "lat" : ""])
                defaults.set("uid", forKey: user.uid)
                completionHandler("Succefuly signup" , true)
            } else if let error = error {
                completionHandler(error.localizedDescription , false)
            }
        }
    }
    func signout(completionHandler:@escaping (_ status:   String, _ success: Bool) -> Void)  {
        defaults.set("uid", forKey: "")
        do{
            try Auth.auth().signOut()
            completionHandler("Successfuly signout",true)
        }
        catch let error as NSError{
            completionHandler(error.localizedDescription,false)
        }
    }
    
    func getListOfUserData(completionHandler:@escaping (_ data: [User]) -> Void){
        ref.observe(.value, with: { snapshot in
            var usersArr = [User]()
            for child in snapshot.children  {
                let child = child as! DataSnapshot
                let value = child.value as! NSDictionary
                if child.key == "users" {
                    for data in value {
                        usersArr.append(User(data: data.value as! NSDictionary))
                    }
                }
            }
            completionHandler(usersArr)
        })
    }
    
    func newPS( name: String, phone: String, longtude: Double, latitude: Double ){
        let currentUserUid = defaults.value(forKey: "uid") as! String
        self.ref.child("PS").child(currentUserUid).setValue(["name": name , "phoneNumber" : phone])
        print("\(longtude),\(latitude)")
        self.ref.child("PS").child(currentUserUid).child("location").setValue(["long" : longtude , "lat" : latitude])
    }
    
    func getListOfPlayStationData(completionHandler:@escaping (_ data: [PlayStation]) -> Void){
        ref.observe(.value, with: { snapshot in
            var psArr = [PlayStation]()
            for child in snapshot.children  {
                let child = child as! DataSnapshot
                let value = child.value as! NSDictionary
                if child.key == "PS" {
                    for data in value {
                        psArr.append(PlayStation(data: data.value as! NSDictionary))
                    }
                }
            }
            completionHandler(psArr)
        })
    }
    
    func updateLocationFor(_ childKey : childKey , longtude : Double, latitude : Double){
        let currentUserUid = defaults.value(forKey: "uid") as! String
        self.ref.child(childKey.rawValue).child(currentUserUid).child("location").setValue(["long" : longtude , "lat" : latitude])
    }
}

