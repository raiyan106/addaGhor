//
//  ShadowView.swift
//  addaGhor
//
//  Created by Raiyan Khan on 25/12/19.
//  Copyright © 2019 Raiyan Khan. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    override func awakeFromNib() {
        self.layer.shadowOpacity = 0.70
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor.black.cgColor
        super.awakeFromNib()
    }
    
}
