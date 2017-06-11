//
//  place.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/10/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import Foundation
class playStation: NSObject ,NSCoding{
    
    var name: String
    var phone: String
    var address: String
    init(name:String,phone:String,address:String) {
        self.name = name
        self.phone = phone
        self.address = address
        
    }
    override init() {
        self.name = ""
        self.phone = ""
        self.address = ""
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        phone = aDecoder.decodeObject(forKey: "Items") as! String
        address = aDecoder.decodeObject(forKey: "IconName") as! String
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(phone, forKey: "Items")
        aCoder.encode(address, forKey: "IconName")
    }
    
}
