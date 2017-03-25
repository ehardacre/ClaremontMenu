//
//  CommentCell.swift
//  Claremont Menu
//
//  Created by Ethan Hardacre on 3/19/17.
//  Copyright © 2017 Ethan Hardacre. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    //this class only houses a text view
    @IBOutlet weak var commentContainer: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
