//
//  FollowingTableViewCell.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 6/6/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import UIKit

class FollowingTableViewCell: UITableViewCell {

    
    @IBOutlet weak var followUserImageView: UIImageView!
    
    
    @IBOutlet weak var followUserNameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        followUserImageView.layer.cornerRadius = followUserImageView.frame.size.height/2
        followUserImageView.layer.borderWidth = 1.0
        followUserImageView.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
