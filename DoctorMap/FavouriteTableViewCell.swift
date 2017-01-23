//
//  FavouriteTableViewCell.swift
//  
//
//  Created by Kushagra Gupta on 22/08/16.
//
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {

    
    @IBOutlet weak var outerView: UIView!
    
    @IBOutlet weak var favImage: UIImageView!
    
    @IBOutlet weak var favName: UILabel!
    
    @IBOutlet weak var favSpeciality: UILabel!
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 0
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.1


    
    override func layoutSubviews() {
        super.layoutSubviews()
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 0)
        outerView.layer.shadowColor = shadowColor?.cgColor
        outerView.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        outerView.layer.shadowOpacity = shadowOpacity
        outerView.layer.shadowPath = shadowPath.cgPath
        favImage.layer.cornerRadius = favImage.frame.width / 2
        outerView.layer.cornerRadius = 2
        
    }

    
}
