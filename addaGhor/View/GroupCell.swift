//
//  GroupCell.swift
//  addaGhor
//
//  Created by Raiyan Khan on 7/1/20.
//  Copyright © 2020 Raiyan Khan. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    
    
    @IBOutlet weak var titleOfGroupField: UILabel!
    
    @IBOutlet weak var descriptionOfGroupField: UILabel!
    
    @IBOutlet weak var totalMembersOfGroupField: UILabel!
    
    
    func configureCell(title: String, description: String, members: Int){
        
        self.titleOfGroupField.text = title
        self.descriptionOfGroupField.text = description
        self.totalMembersOfGroupField.text = String(members)
    }
    
}
