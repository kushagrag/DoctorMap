//
//  Doctor.swift
//  DoctorMap
//
//  Created by Kushagra Gupta on 21/08/16.
//  Copyright © 2016 Kushagra Gupta. All rights reserved.
//

import UIKit
import CoreData

class Doctor: NSObject {
    
    var docId:Int!
    var name:String!
    var speciality:String!
    var photoUrl:String!
    var longitude:Double!
    var latitude:Double!
    var marker:GMSMarker!
    
    init(docId: Int, name: String, speciality:String, photoUrl:String, longitude:Double, latitude:Double, marker:GMSMarker){
        
        self.docId = docId
        self.name = name
        self.speciality = speciality
        self.photoUrl = photoUrl
        self.longitude = longitude
        self.latitude = latitude
        self.marker = marker
        
    }

}
