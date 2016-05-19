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
    var id: Int!
    var firstName: String!
    var lastName: String!
    var middleName: String!
    var email: String = ""
    var avatarUrl: String? = nil
    
    required init?(_ map: Map) {
        
    }    

    func mapping(map: Map) {
        id <- map["id"]
        email <- map["email"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        middleName <- map["middle_name"]
        avatarUrl <- map["image.url"]
    }
    
    func getCorrectName() -> String{
        var name: String?
        
        if (firstName != nil && lastName != nil) {
            name = "\(firstName) \(lastName)"
        }
        else {
            name = email
        }
        return name!
    }
    
    func fullAvatarUrl() -> String? {
        if let url = avatarUrl {
            return url
        }
        else {
            return nil
        }
    }
}