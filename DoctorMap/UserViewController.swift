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
    
    //MARK: Properties
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var backgrounImage: UIImageView!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgrounImage.image = UIImage(named: "profile-bg")
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = 10.0
        profileImage.clipsToBounds = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "userId == %@", currentUser.userID)
        
        do{
            let user = try managedContext.fetch(fetchRequest)
            profileImage.image = UIImage(data: user[0].value(forKey: "photo") as! Data)
            name.text = user[0].value(forKey: "name") as? String
            email.text = user[0].value(forKey: "email") as? String
        }catch let error as NSError{
            print("Cannot Fetch Data, \(error)")
        }
    }
   
    //MARK: Actions
    
    @IBAction func signOut(_ sender: UIButton) {
        let signOutAlert = UIAlertController(title: "SignOut", message: "Really want to Sign Out", preferredStyle: .actionSheet)
        
        let signOutAction = UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
             GIDSignIn.sharedInstance().signOut()
             self.performSegue(withIdentifier: "showSignSegue", sender: self)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        })
        
        signOutAlert.addAction(signOutAction)
        signOutAlert.addAction(cancelAction)
        
        present(signOutAlert, animated: true, completion: nil)

       
    }
}
