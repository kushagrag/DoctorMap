//
//  CarouselTableViewCell.swift
//  DoctorMap
//
//  Created by Kushagra Gupta on 17/08/16.
//  Copyright © 2016 Kushagra Gupta. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class CarouselTableViewCell:UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 10
    
    @IBInspectable var shadowOffsetWidth: Int = 5
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.blackColor()
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        
        
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.CGColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.CGPath
    }
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var speciality: UILabel!
    
    var docId:Int!
    
    var isFav = false
    
    @IBAction func addRemoveFav(sender: AnyObject) {
        
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
        
        let entityDoctor = NSEntityDescription.entityForName("Doctors", inManagedObjectContext: managedContext)
        
        if isFav == false {
            favouriteButton.setImage(UIImage(named: "filledStar"), forState: .Normal)
            isFav = true
            favDoctorList.append(docId)
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
                            Alamofire.request(.GET, doc.photoUrl).responseJSON{response in
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
               }catch let error as NSError{
                print("\(error), \(error.userInfo)")
                }
            }

        }
        else{
            favDoctorList.removeAtIndex(favDoctorList.indexOf(docId)!)
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
            }catch let error as NSError{
                print("\(error), \(error.userInfo)")
            }
            
            favouriteButton.setImage(UIImage(named: "emptyStar"), forState: .Normal)
            isFav = false
        }
    }
    
}
