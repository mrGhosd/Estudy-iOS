//
//  User.swift
//  Estudy
//
//  Created by vsokoltsov on 04.11.15.
//  Copyright © 2015 vsokoltsov. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    var firstName = ""
    var secondName = ""
    var middleName = ""
    var email: String = ""
    var avatarUrl: String? = nil
    
    required init?(_ map: Map) {
        
    }    

    func mapping(map: Map) {
        email <- map["email"]
        avatarUrl <- map["image.url"]
    }
    
    func fullAvatarUrl() -> String? {
        if let url = avatarUrl {
            return "\(ApiRequest.sharedInstance.host)\(url)"
        }
        else {
            return nil
        }
    }
}