//
//  Message.swift
//  Estudy
//
//  Created by vsokoltsov on 28.02.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import Foundation
import ObjectMapper

class Message: Mappable {
    var chat: Chat!
    var user: User!
    var createdAt: NSDate!
    var text: String!
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
       text <- map["text"]
       chat <- map["chat"]
       user <- map["user"]
       createdAt    <- (map["created_at"], DateTransform())
    }
}