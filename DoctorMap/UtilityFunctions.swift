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
        do {
            let reachability:Reachability =  try Reachability.reachabilityForInternetConnection()
            
            switch reachability.currentReachabilityStatus{
            case .ReachableViaWiFi:
                print("Connected With wifi")
                return true
            case .ReachableViaWWAN:
                print("Connected With Cellular network(3G/4G)")
                return true
            case .NotReachable:
                print("Not Connected")
                return false
            }
        }
        catch let error as NSError{
            print(error.debugDescription)
            return false
        }
    }
    
}

//Utility to create an alert 

extension UIViewController {
    
    func alert(message: String, title: String, handler: (UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: handler)
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}