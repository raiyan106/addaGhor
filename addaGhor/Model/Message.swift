//
//  Message.swift
//  addaGhor
//
//  Created by Raiyan Khan on 28/12/19.
//  Copyright © 2019 Raiyan Khan. All rights reserved.
//

import Foundation
import UIKit
class Message{
    private var _content: String
    private var _senderID: String
    private var _time: String
    
    var content: String{
        return _content
    }
    var senderId: String{
        return _senderID
    }
    var time: String{
        return _time
    }
    init(content: String, senderId: String, time: String) {
        self._content = content
        self._senderID = senderId
        self._time = time
    }
}
