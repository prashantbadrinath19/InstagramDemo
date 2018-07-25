//
//  PostTableViewCell.swift
//  InstagramApp
//
//  Created by Prashant  Badrinath on 5/30/18.
//  Copyright © 2018 Prashant  Badrinath. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dpImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var likeButtonAction: UIButton!
    @IBOutlet weak var like_count: UIButton!
    @IBOutlet weak var postTimestampLbl: UILabel!
    
    @IBOutlet weak var comment_btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dpImageView.layer.cornerRadius = dpImageView.frame.size.height/2
        dpImageView.layer.borderWidth = 1.0
        dpImageView.layer.borderColor = UIColor.black.cgColor
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
