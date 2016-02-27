//
//  Chat.swift
//  Estudy
//
//  Created by vsokoltsov on 28.02.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import Foundation
import ObjectMapper

class Chat: Mappable {
    var id: Int?
    var createdAt: NSDate?
    var users: [User]?
    var messages: [Message]!
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        id    <- map["id"]
        createdAt    <- (map["created_at"], DateTransform())
        users <- map["users"]
        messages <- map["messages"]
    }
}