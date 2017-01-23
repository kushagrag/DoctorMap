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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "userId == %@", currentUser.userID)
        
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            if (results.count == 0){
                print("User Created")
                let entity =  NSEntityDescription.entity(forEntityName: "User",
                                                         in:managedContext)
                let user = NSManagedObject(entity: entity!,
                                           insertInto: managedContext)
                user.setValue(currentUser.userID, forKey: "userId")
                user.setValue(currentUser.profile.name, forKey: "name")
                user.setValue(currentUser.profile.email, forKey: "email")
                var photo:Data!
                if currentUser.profile.hasImage == true{
                    Alamofire.request(currentUser.profile.imageURL(withDimension: 128)).responseJSON{response in
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
    
    static func addFavourite(_ docId : Int) -> Bool{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "userId == %@", currentUser.userID)
        
        var curUser:AnyObject!
        do{
            let users = try managedContext.fetch(fetchRequest)
            curUser = users[0]
            print(curUser.value(forKey: "userId"))
            
        }catch let error as NSError {
            print("Could not Fetch \(error), \(error.userInfo)")
        }
        
        do{
            var curFavDoctorList:[Int] = []
            if curUser.value(forKey:"favDoctors") != nil{
                curFavDoctorList = curUser.value(forKey:"favDoctors") as! [Int]
            }
            curFavDoctorList.append(docId)
            curUser.setValue(curFavDoctorList, forKey: "favDoctors")
            print(curFavDoctorList)
            
            fetchRequest = NSFetchRequest(entityName: "Doctors")
            fetchRequest.predicate = NSPredicate(format: "docId == %ld", docId)
            let entityDoctor = NSEntityDescription.entity(forEntityName: "Doctors", in: managedContext)
            
            do{
                let curDoctor = try managedContext.fetch(fetchRequest)
                if curDoctor.count == 0{
                    let doc = doctors[doctors.index(where: {$0.docId == docId})!]
                    let doctor = NSManagedObject(entity: entityDoctor!, insertInto: managedContext)
                    doctor.setValue(doc.name, forKey: "name")
                    doctor.setValue(doc.docId, forKey: "docId")
                    doctor.setValue(doc.speciality, forKey: "speciality")
                    doctor.setValue(doc.longitude, forKey: "longitude")
                    doctor.setValue(doc.latitude, forKey: "latitude")
                    var photo:Data!
                    if doc.photoUrl == "docImage"{
                        photo = (UIImagePNGRepresentation(UIImage(named: doc.photoUrl)!) as NSData!) as Data!
                        doctor.setValue(photo, forKey: "photo")
                        try managedContext.save()
                    }
                    else{
                        let photoUrl = (doc.photoUrl).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        Alamofire.request(photoUrl!).responseJSON{response in
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
                    let noOfReferences = curDoctor[0].value(forKey:"noOfReferences") as! Int
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
    
    static func removeFavourite(_ docId : Int) -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "userId == %@", currentUser.userID)
        
        var curUser:AnyObject!
        do{
            let users = try managedContext.fetch(fetchRequest)
            curUser = users[0]
            print(curUser.value(forKey:"userId"))
            
        }catch let error as NSError {
            print("Could not Fetch \(error), \(error.userInfo)")
        }

        fetchRequest = NSFetchRequest(entityName: "Doctors")
        fetchRequest.predicate = NSPredicate(format: "docId == %ld", docId)
        
        do{
            var curDoctorList = curUser.value(forKey:"favDoctors") as! [Int]
            curDoctorList.remove(at: curDoctorList.index(of: docId)!)
            curUser.setValue(curDoctorList, forKey: "favDoctors")
            let curDoctor = try managedContext.fetch(fetchRequest)
            let noOfReferences = curDoctor[0].value(forKey:"noOfReferences") as! Int
            if noOfReferences == 0{
                managedContext.delete(curDoctor[0])
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
