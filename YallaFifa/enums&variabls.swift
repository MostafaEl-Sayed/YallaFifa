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
