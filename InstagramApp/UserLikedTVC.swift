//
//  UserLikedTVC.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 6/1/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import UIKit

class UserLikedTVC: UITableViewCell {
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImage.layer.cornerRadius = userImage.frame.size.height/2
        userImage.layer.borderWidth = 1.0
        userImage.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
