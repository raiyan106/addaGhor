//
//  Date.swift
//  addaGhor
//
//  Created by Raiyan Khan on 4/1/20.
//  Copyright © 2020 Raiyan Khan. All rights reserved.
//

import Foundation

class CurrentTime{
    static let time = CurrentTime()
    
    func now()->String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        return format.string(from: date)
    }
}
