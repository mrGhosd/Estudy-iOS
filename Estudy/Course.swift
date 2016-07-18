//
//  Course.swift
//  Estudy
//
//  Created by vsokoltsov on 19.07.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import Foundation
import ObjectMapper

class Course: Mappable {
    var id: Int!
    var title: String!
    var shortDescription: String!
    var imageUrl: String? = nil
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        shortDescription <- map["short_description"]
        imageUrl <- map["image.url"]
    }
    
    func fullImageUrl() -> String? {
        if let url = imageUrl {
            return url
        }
        else {
            return nil
        }
    }

}
