//
//  FavouriteTableViewCell.swift
//  
//
//  Created by Kushagra Gupta on 22/08/16.
//
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {


    @IBInspectable var cornerRadius: CGFloat = 10
    
    @IBOutlet weak var outerView: UIView!
    override func layoutSubviews() {
        outerView.layer.cornerRadius = cornerRadius
    }

    @IBOutlet weak var favImage: UIImageView!
    
    @IBOutlet weak var favName: UILabel!
    
    @IBOutlet weak var favSpeciality: UILabel!
    
}
