//
//  IdDateObject.swift
//  ThreeDModels
//
//  Created by cc on 10/01/2019.
//  Copyright © 2019 com.binaryalchemist. All rights reserved.
//

import Foundation

class IdDateObject: NSObject{
    
    var id : Int?
    var date : Date?
    
    init(id: Int, date: Date){
        self.id = id
        self.date = date
    }
    
}
