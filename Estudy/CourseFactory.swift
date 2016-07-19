//
//  CourseFactory.swift
//  Estudy
//
//  Created by vsokoltsov on 19.07.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class CourseFactory: NSObject {
    class var instance: CourseFactory {
        struct Singleton {
            static let instance: CourseFactory = CourseFactory()
        }
        
        return Singleton.instance
    }
    
    class func getCollection(parameters: NSDictionary, success: ([Course]) -> Void, error: (ServerError) -> Void) -> Void{
        ApiRequest.sharedInstance.get("/courses", parameters: parameters)
            .responseArray("courses", completionHandler: { (response: Response<[Course], NSError>) in
                switch(response.result) {
                case .Success(let data):
                    success(data)
                case .Failure(let errorData):
                    let errorValue = ServerError(parameters: errorData)
                    error(errorValue)
                }
            })
    }
    
    class func search(parameters: NSDictionary, success: ([Course]) -> Void, error: (ServerError) -> Void) -> Void {
        ApiRequest.sharedInstance.get("/search", parameters: parameters)
            .responseArray("search", completionHandler: { (response: Response<[Course], NSError>) in
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
