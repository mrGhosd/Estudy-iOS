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
    var difficult: String!
    
    required init?(_ map: Map) {
        
    }
    
    func getCourseDifficultNumber() -> Int {
        var number: Int!
        switch difficult {
            case "easy":
                number = 1
            case "medium":
                number = 2
            case "hard":
                number = 3
            default:
                number = 1
        }
        return number
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        shortDescription <- map["short_description"]
        imageUrl <- map["image.url"]
        difficult <- map["difficult"]
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
