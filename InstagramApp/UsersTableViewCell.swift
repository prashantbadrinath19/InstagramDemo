//
//  UsersTableViewCell.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 5/30/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameLabl: UILabel!
    
    
    @IBOutlet weak var followAction: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.black.cgColor
        // Initialization code
    }

    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
