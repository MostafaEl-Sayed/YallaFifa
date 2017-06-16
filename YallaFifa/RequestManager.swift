//
//  RequestManager.swift
//  Future Center
//
//  Created by MsZ on 8/23/16.
//  Copyright © 2016 MsZ. All rights reserved.
//

import Foundation


class RequestManager{
    
    
    static let defaultManager = RequestManager()
    private init (){}
    
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
    
}

