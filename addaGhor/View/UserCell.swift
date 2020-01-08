//
//  UserCell.swift
//  addaGhor
//
//  Created by Raiyan Khan on 4/1/20.
//  Copyright © 2020 Raiyan Khan. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {


    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    
    
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        if selected{
//            if isShowing == false {
//                checkImg.isHidden = false
//                isShowing = true
//            } else{
//                checkImg.isHidden = true
//                isShowing = false
//            }
//        }
//    }
    
    func configureCell(profileImg: UIImage, email: String, isSelected: Bool){
        self.profileImg.image = profileImg
        self.emailLabel.text = email
        if isSelected{
                self.checkImg.isHidden = false
        }
        else {
            self.checkImg.isHidden = true
        }
    }

}
