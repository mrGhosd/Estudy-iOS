//
//  User.swift
//  Estudy
//
//  Created by vsokoltsov on 04.11.15.
//  Copyright © 2015 vsokoltsov. All rights reserved.
//

import Foundation
import SwiftyJSON

class User : NSObject {
    var firstName = ""
    var secondName = ""
    var middleName = ""
    var email: String = ""
    var avatarUrl: String = ""
    
    init(parameters: JSON){
        self.email = parameters["email"].stringValue
    }
}