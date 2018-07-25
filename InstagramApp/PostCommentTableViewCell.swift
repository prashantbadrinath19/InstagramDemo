//
//  PostCommentTableViewCell.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 6/7/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import UIKit

class PostCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userComment: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var timeEnlapsed: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.layer.cornerRadius = userImage.frame.size.height/2
        userImage.layer.borderWidth = 1.0
        userImage.layer.borderColor = UIColor.black.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
