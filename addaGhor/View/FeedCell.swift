//
//  FeedCell.swift
//  addaGhor
//
//  Created by Raiyan Khan on 28/12/19.
//  Copyright © 2019 Raiyan Khan. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    func configureCell(profileImage: UIImage, email: String, content: String, time: String){
        self.profileImage.image = profileImage
        self.emailLabel.text = email
        self.contentLabel.text = content
        self.timeLabel.text = time
    }
    
    
    
}
