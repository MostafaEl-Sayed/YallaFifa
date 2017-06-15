//
//  PSLocationsVC.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/9/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import UIKit

class PSLocationsViewController: GlobalController {

    //@IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var psNameTextField: UITextField!
    @IBOutlet weak var psPhoneNumberTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var psLocations = [User]()
    var currentPSLocationAddress = "Address1"
    var psChoosedLocation = [String : Double]()
    
//    struct TableViewCellIdentifiers {
//        static let psDetailsCell = "PSDetailsCell"
//        static let nothingFoundCell = "NothingFoundCell"
//    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollViewInitilaizer(scrollView: scrollView)
        
//        tableView.tableFooterView = UIView()
//        
//        var cellNib = UINib(nibName: TableViewCellIdentifiers.psDetailsCell, bundle: nil)
//        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.psDetailsCell)
//        
//        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
//        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
        
    }

   
    @IBAction func backBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addNewPSLocation(_ sender: Any) {
        self.view.endEditing(true)
//        let newPS = User(name: self.psNameTextField.text!, phone: self.psPhoneNumberTextField.text!, address: currentPSLocationAddress,location: psChoosedLocation,typeOfUser: "PS")
//        self.psLocations.append(newPS)
//        self.tableView.reloadData()
    }
    // ------------------------------------------
    
   

}

//extension PSLocationsViewController: UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView,
//                   numberOfRowsInSection section: Int) -> Int {
//        print("bs geet")
//        print("\(psLocations.count)")
//        switch psLocations.count {
//        case 0:
//            return 1
//        default:
//            print("geet hna wl count\(psLocations.count)")
//            return psLocations.count
//        }
//    }
//    
//    func tableView(_ tableView: UITableView,
//                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch psLocations.count {
//        case 0:
//            print("geet hna wl count\(psLocations.count)")
//            return self.tableView.dequeueReusableCell(
//                withIdentifier: TableViewCellIdentifiers.nothingFoundCell,
//                for: indexPath)
//            
//           
//        default :
//            print("geet hna wl count\(psLocations.count)")
//            let cell = self.tableView.dequeueReusableCell(
//                withIdentifier: TableViewCellIdentifiers.psDetailsCell,
//                for: indexPath) as! PSDetailsTableViewCell
//            
//            let psLocation = psLocations[indexPath.row]
//            cell.configure(newPS: psLocation)
//            return cell
//        }
//    }
//}
//
//extension PSLocationsViewController: UITableViewDelegate {
//    
////   func tableView(_ tableView: UITableView,
////                  didSelectRowAt indexPath: IndexPath) {
//        
////        if view.window!.rootViewController!.traitCollection.horizontalSizeClass == .compact {
////            tableView.deselectRow(at: indexPath, animated: true)
////            performSegue(withIdentifier: "ShowDetail", sender: indexPath)
////            
////        } else {
////            if case .results(let list) = search.state {
////                splitViewDetail?.searchResult = list[indexPath.row]
////            }
////            if splitViewController!.displayMode != .allVisible {
////                hideMasterPane()
////            }      
////        }
////    }
////    
////    func tableView(_ tableView: UITableView,
////                   willSelectRowAt indexPath: IndexPath) -> IndexPath? {
////        switch search.state {
////        case .notSearchedYet, .loading, .noResults:
////            return nil
////        case .results:
////            return indexPath
////        }
////    }
////}
//}
