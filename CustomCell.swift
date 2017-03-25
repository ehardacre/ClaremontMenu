//
//  CustomCell.swift
//  Claremont Menu
//
//  Created by Ethan Hardacre on 1/19/17.
//  Copyright © 2017 Ethan Hardacre. All rights reserved.
//

import UIKit
import Cosmos

class CustomCell: UITableViewCell {
    //UI elements of the custom tableView cells
    @IBOutlet weak var gradientBG: UIView!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodRating: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //formatting UI elements
        foodImage.layer.cornerRadius = foodImage.frame.width / 2
        foodImage.layer.borderWidth = 2
        foodImage.layer.borderColor = UIColor.white.cgColor
        foodImage.image = #imageLiteral(resourceName: "defaultFood")
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
