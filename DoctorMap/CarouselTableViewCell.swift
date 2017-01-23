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
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        
        
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        photoView.layer.cornerRadius = 2
    }
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var speciality: UILabel!
    
    var docId:Int!
    
    var isFav = false
    
    @IBAction func addRemoveFav(_ sender: AnyObject) {
        
        
        if isFav == false {
            favouriteButton.setImage(UIImage(named: "filledStar"), for: .normal)
            isFav = true
            favDoctorList.append(docId)
            DatabaseHelper.addFavourite(docId)
            
        }
        else{
            favDoctorList.remove(at: favDoctorList.index(of: docId)!)
            isFav = false
            favouriteButton.setImage(UIImage(named: "emptyStar"), for: .normal)
            DatabaseHelper.removeFavourite(docId)
            
        }
    }
    
}
