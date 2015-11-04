//
//  CustomCell.swift
//  MontrealPoutine
//
//  Created by Jean-Guy Bergeron on 2015-05-05.
//  Copyright (c) 2015 Jean-Guy Bergeron. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var poutineLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var signetImage: UIImageView!

    @IBOutlet weak var adresseLabel: UILabel!
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var fiveStarsRate: FloatRatingView!
    
    @IBOutlet weak var imageSpecial: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        logoImage.layer.cornerRadius = logoImage.bounds.size.width / 2
        logoImage.clipsToBounds = true
        separatorInset = UIEdgeInsets(top: 0, left: 82, bottom: 0, right: 0)

        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
