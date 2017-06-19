//
//  place.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/10/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import Foundation
class User: NSObject ,NSCoding {
    
    var email: String
    var phone: String
    var location: Location!
    var typeOfUser:String
    
    init(data: NSDictionary) {
        self.email = data.getValueForKey(Key: "email", callBack: "")
        self.phone = data.getValueForKey(Key: "phoneNumber", callBack: "")
        self.location = Location(data: data.getValueForKey(Key: "location" , callBack: [:]))
        self.typeOfUser = "online"
    }
    
    override init() {
        self.email = ""
        self.phone = ""
        self.location = Location()
        self.typeOfUser = ""
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        email = aDecoder.decodeObject(forKey: "Email") as! String
        phone = aDecoder.decodeObject(forKey: "Phone") as! String
        location = aDecoder.decodeObject(forKey: "Location") as! Location
        typeOfUser = aDecoder.decodeObject(forKey: "typeOfUser") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(email, forKey: "Email")
        aCoder.encode(phone, forKey: "Phone")
        aCoder.encode(location, forKey: "Location")
        aCoder.encode(typeOfUser, forKey: "typeOfUser")
    }
    
}


class Location : NSObject ,NSCoding {
    
    var latitude : Double!
    var longtude : Double!
    
    init(data: NSDictionary) {
        latitude = data.getValueForKey(Key: "lat", callBack: 0.0)
        longtude = data.getValueForKey(Key: "long", callBack: 0.0)
    }
    
    override init() {
        latitude = 0.0
        longtude = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        latitude = aDecoder.decodeObject(forKey: "latitude") as! Double
        longtude = aDecoder.decodeObject(forKey: "longtude") as! Double
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longtude, forKey: "longtude")
    }
}
