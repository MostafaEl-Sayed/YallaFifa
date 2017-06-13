//
//  place.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/10/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import Foundation
class User: NSObject ,NSCoding{
    
    var name: String
    var phone: String
    var address: String
    var location: [String:Double]
    
    init(name:String,phone:String,address:String,location:[String : Double]) {
        self.name = name
        self.phone = phone
        self.address = address
        self.location = location
    }
    override init() {
        self.name = ""
        self.phone = ""
        self.address = ""
        self.location = [String : Double]()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        phone = aDecoder.decodeObject(forKey: "Phone") as! String
        address = aDecoder.decodeObject(forKey: "Address") as! String
        location = aDecoder.decodeObject(forKey: "Location") as! [String:Double]
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(phone, forKey: "Phone")
        aCoder.encode(address, forKey: "Address")
        aCoder.encode(location, forKey: "Location")
    }
    
}
