//
//  GroupMessage.swift
//  addaGhor
//
//  Created by Raiyan Khan on 7/1/20.
//  Copyright © 2020 Raiyan Khan. All rights reserved.
//

import Foundation


class GroupMessage{
  
    private var _title: String
    private var _description: String
    private var _members: [String]
    private var _groupKey: String
    private var _totalMembers: Int
    
    var title: String{
        return _title
    }
    
    var description: String{
        return _description
    }
    
    var members: [String] {
        return _members
    }
    
    var groupKey: String{
        return _groupKey
    }
    
    var totalMembers: Int{
        return _totalMembers
    }
    
    init(title: String, description: String, members: [String], groupKey: String, totalMembers: Int){
        self._title = title
        self._description = description
        self._members = members
        self._groupKey = groupKey
        self._totalMembers  = totalMembers
    }
    
}

