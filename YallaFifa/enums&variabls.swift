//
//  enums&variabls.swift
//  YallaFifa
//
//  Created by Ahmed Hussien on 6/11/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import Foundation
import UIKit

let defaults = UserDefaults.standard

extension UIViewController{
    func presentAlert(title : String , mssg : String){
        let alertController = UIAlertController(title: title, message: mssg, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIColor {
    convenience init(hex: String , alphaNum: CGFloat) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: alphaNum
        )
    }
}
