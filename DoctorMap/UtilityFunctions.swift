//
//  UtilityFunctions.swift
//  DoctorMap
//
//  Created by Kushagra Gupta on 28/08/16.
//  Copyright © 2016 Kushagra Gupta. All rights reserved.
//

import Foundation
import ReachabilitySwift

class UtiltyFunction{
    
    
    
    static func checkInternetConnection() -> Bool{
            let reachability:Reachability =  Reachability()!
            
            switch reachability.currentReachabilityStatus{
            case .reachableViaWiFi:
                print("Connected With wifi")
                return true
            case .reachableViaWWAN:
                print("Connected With Cellular network(3G/4G)")
                return true
            case .notReachable:
                print("Not Connected")
                return false
            }
    }
    
}

//Utility to create an alert 

extension UIViewController {
    
    func alert(_ message: String, title: String, handler: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
