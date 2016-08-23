//
//  CarouselView.swift
//  
//
//  Created by Kushagra Gupta on 18/08/16.
//
//

import UIKit

class CarouselView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 10
    
    @IBInspectable var shadowOffsetWidth: Int = 5
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.blackColor()
    @IBInspectable var shadowOpacity: Float = 0.5
    @IBOutlet weak var iView: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var specL: UILabel!
    
    override func layoutSubviews() {
        
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.CGColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.CGPath
    }
    
    

}
