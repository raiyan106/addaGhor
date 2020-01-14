//
//  UIImgExt.swift
//  addaGhor
//
//  Created by Raiyan Khan on 11/1/20.
//  Copyright © 2020 Raiyan Khan. All rights reserved.
//

import UIKit
extension UIImageView {

    func makeRounded() {

        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
//        self.layer.borderColor = UIColor.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    
}
