//
//  GroupFeedCell.swift
//  addaGhor
//
//  Created by Raiyan Khan on 7/1/20.
//  Copyright © 2020 Raiyan Khan. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {


    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var timeOfMsgLabel: UILabel!
    @IBOutlet weak var msgContentLabel: UILabel!
    
    func configure(profileImg: UIImage, userEmail: String, timeOfMsg: String, msgContent: String){
        self.profileImg.image = profileImg
        self.userEmailLbl.text = userEmail
        self.timeOfMsgLabel.text = timeOfMsg
        self.msgContentLabel.text = msgContent
        
    }
    
}
