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
    
    @IBInspectable var cornerRadius: CGFloat = 5
    
    @IBInspectable var shadowOffsetWidth: Int = 2
    @IBInspectable var shadowOffsetHeight: Int = 2
    @IBInspectable var shadowColor: UIColor? = UIColor.blackColor()
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        
        
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowColor = shadowColor?.CGColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.CGPath
        photoView.layer.cornerRadius = 2
    }
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var speciality: UILabel!
    
    var docId:Int!
    
    var isFav = false
    
    @IBAction func addRemoveFav(sender: AnyObject) {
        
        
        if isFav == false {
            favouriteButton.setImage(UIImage(named: "filledStar"), forState: .Normal)
            isFav = true
            favDoctorList.append(docId)
            DatabaseHelper.addFavourite(docId)
            
        }
        else{
            favDoctorList.removeAtIndex(favDoctorList.indexOf(docId)!)
            isFav = false
            favouriteButton.setImage(UIImage(named: "emptyStar"), forState: .Normal)
            DatabaseHelper.removeFavourite(docId)
            
        }
    }
    
}
