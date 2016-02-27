//
//  UserFactory.swift
//  Estudy
//
//  Created by vsokoltsov on 21.02.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//
import UIKit
import SwiftyJSON
import Alamofire
import AlamofireObjectMapper


class UserFactory: NSObject {
    class var instance: UserFactory {
        struct Singleton {
            static let instance: UserFactory = UserFactory()
        }
        
        return Singleton.instance
    }
    
    class func getCollection(parameters: NSDictionary, success: ([User]) -> Void, error: (ServerError) -> Void) -> Void{
        ApiRequest.sharedInstance.get("/users", parameters: parameters)
            .responseArray("users", completionHandler: { (response: Response<[User], NSError>) in
                switch(response.result) {
                    case .Success(let data):
                        success(data)
                    case .Failure(let errorData):
                        let errorValue = ServerError(parameters: errorData)
                        error(errorValue)
                }
        })
    }
}