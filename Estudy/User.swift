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
    var avatarUrl: String? = nil
    
    init(parameters: JSON){
        self.email = parameters["email"].stringValue
        if parameters["image"] != nil{
            self.avatarUrl = "http://localhost:3000\(parameters["image"]["file"]["url"])"
        }
    }
    
    class func getCollection(url: String, parameters: NSDictionary, success: ([User]) -> Void, error: (ServerError) -> Void) -> Void{
        ApiRequest.sharedInstance.get(url, parameters: parameters,
            success: {(objects: JSON) in
                var usersList:[User] = []
                for object in objects{
                    let user = User(parameters: object.1)
                    usersList.append(user)
                }
                success(usersList)
            },
            error: {(errors: NSError) in
                let serverError = ServerError(parameters: errors)
                error(serverError)
            })
    }
}