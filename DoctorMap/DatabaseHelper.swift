//
//  DatabaseHelper.swift
//  DoctorMap
//
//  Created by Kushagra Gupta on 28/08/16.
//  Copyright © 2016 Kushagra Gupta. All rights reserved.
//

import CoreData
import Alamofire

class DatabaseHelper{
    
    //Create User
    
    static func createUser() -> Bool{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "userId == %@", currentUser.userID)
        
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            if (results.count == 0){
                print("User Created")
                let entity =  NSEntityDescription.entityForName("User",
                                                                inManagedObjectContext:managedContext)
                let user = NSManagedObject(entity: entity!,
                                           insertIntoManagedObjectContext: managedContext)
                user.setValue(currentUser.userID, forKey: "userId")
                user.setValue(currentUser.profile.name, forKey: "name")
                user.setValue(currentUser.profile.email, forKey: "email")
                var photo:NSData!
                if currentUser.profile.hasImage == true{
                    Alamofire.request(.GET, currentUser.profile.imageURLWithDimension(128)).responseJSON{response in
                        photo = response.data!
                        user.setValue(photo, forKey: "photo")
                        do {
                            try managedContext.save()
                        } catch let error as NSError  {
                            print("Could not save \(error), \(error.userInfo)")
                        }
                    }
                    
                }
                else{
                    photo = UIImagePNGRepresentation(UIImage(named: "profile-default")!)
                    user.setValue(photo, forKey: "photo")
                    do {
                        try managedContext.save()
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                }
                
            }
            return true
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return false
        }
        
    }
    
    //Add Favourites
    
    static func addFavourite(docId : Int) -> Bool{
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "userId == %@", currentUser.userID)
        
        var curUser:AnyObject!
        do{
            let users = try managedContext.executeFetchRequest(fetchRequest)
            curUser = users[0]
            print(curUser.valueForKey("userId"))
            
        }catch let error as NSError {
            print("Could not Fetch \(error), \(error.userInfo)")
        }
        
        do{
            var curFavDoctorList:[Int] = []
            if curUser.valueForKey("favDoctors") != nil{
                curFavDoctorList = curUser.valueForKey("favDoctors") as! [Int]
            }
            curFavDoctorList.append(docId)
            curUser.setValue(curFavDoctorList, forKey: "favDoctors")
            print(curFavDoctorList)
            
            fetchRequest = NSFetchRequest(entityName: "Doctors")
            fetchRequest.predicate = NSPredicate(format: "docId == %ld", docId)
            let entityDoctor = NSEntityDescription.entityForName("Doctors", inManagedObjectContext: managedContext)
            
            do{
                let curDoctor = try managedContext.executeFetchRequest(fetchRequest)
                if curDoctor.count == 0{
                    let doc = doctors[doctors.indexOf({$0.docId == docId})!]
                    let doctor = NSManagedObject(entity: entityDoctor!, insertIntoManagedObjectContext: managedContext)
                    doctor.setValue(doc.name, forKey: "name")
                    doctor.setValue(doc.docId, forKey: "docId")
                    doctor.setValue(doc.speciality, forKey: "speciality")
                    doctor.setValue(doc.longitude, forKey: "longitude")
                    doctor.setValue(doc.latitude, forKey: "latitude")
                    var photo:NSData!
                    if doc.photoUrl == "docImage"{
                        photo = UIImagePNGRepresentation(UIImage(named: doc.photoUrl)!)
                        doctor.setValue(photo, forKey: "photo")
                        try managedContext.save()
                    }
                    else{
                        let photoUrl = (doc.photoUrl).stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
                        Alamofire.request(.GET, photoUrl!).responseJSON{response in
                            photo = response.data!
                            doctor.setValue(photo, forKey: "photo")
                            do{
                                try managedContext.save()
                            }catch let error as NSError{
                                print("\(error)")
                            }
                        }
                    }
                    
                }
                else{
                    let noOfReferences = curDoctor[0].valueForKey("noOfReferences") as! Int
                    curDoctor[0].setValue(noOfReferences + 1, forKey: "noOfReferences")
                    try managedContext.save()
                }
                return true
            }catch let error as NSError{
                print("\(error), \(error.userInfo)")
                return false
            }
        }

    }
    
    //Remove Favourites
    
    static func removeFavourite(docId : Int) -> Bool{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "userId == %@", currentUser.userID)
        
        var curUser:AnyObject!
        do{
            let users = try managedContext.executeFetchRequest(fetchRequest)
            curUser = users[0]
            print(curUser.valueForKey("userId"))
            
        }catch let error as NSError {
            print("Could not Fetch \(error), \(error.userInfo)")
        }

        fetchRequest = NSFetchRequest(entityName: "Doctors")
        fetchRequest.predicate = NSPredicate(format: "docId == %ld", docId)
        
        do{
            var curDoctorList = curUser.valueForKey("favDoctors") as! [Int]
            curDoctorList.removeAtIndex(curDoctorList.indexOf(docId)!)
            curUser.setValue(curDoctorList, forKey: "favDoctors")
            let curDoctor = try managedContext.executeFetchRequest(fetchRequest)
            let noOfReferences = curDoctor[0].valueForKey("noOfReferences") as! Int
            if noOfReferences == 0{
                managedContext.deleteObject(curDoctor[0] as! NSManagedObject)
            }
            else {
                curDoctor[0].setValue(noOfReferences - 1, forKey: "noOfReferences")
            }
            try managedContext.save()
            return true
        }catch let error as NSError{
            print("\(error), \(error.userInfo)")
            return false
        }

    }
    
}
