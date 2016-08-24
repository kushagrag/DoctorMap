//
//  UserViewController.swift
//  DoctorMap
//
//  Created by Kushagra Gupta on 21/08/16.
//  Copyright © 2016 Kushagra Gupta. All rights reserved.
//

import UIKit
import CoreData

class UserViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var backgrounImage: UIImageView!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgrounImage.image = UIImage(named: "profile-bg")
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        profileImage.layer.cornerRadius = 10.0
        profileImage.clipsToBounds = true
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "userId == %@", currentUser.userID)
        
        do{
            let user = try managedContext.executeFetchRequest(fetchRequest)
            profileImage.image = UIImage(data: user[0].valueForKey("photo") as! NSData)
            name.text = user[0].valueForKey("name") as? String
            email.text = user[0].valueForKey("email") as? String
        }catch let error as NSError{
            print("Cannot Fetch Data, \(error)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
           tabBarController?.tabBar.hidden = false
    }
    
    
   
    
    @IBAction func signOut(sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
    }
}
