//
//  ApiRequest.swift
//  Estudy
//
//  Created by vsokoltsov on 04.11.15.
//  Copyright © 2015 vsokoltsov. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import AlamofireObjectMapper
import SwiftyJSON

public enum Method: String {
    case GET, HEAD, POST, PUT, PATCH, DELETE
}

class ApiRequest: NSObject {
    var host = "http://localhost:3000"
    class var sharedInstance: ApiRequest {
        struct Singleton {
            static let instance: ApiRequest = ApiRequest()
        }
        
        return Singleton.instance
    }
    
    func get(url: String, parameters: NSDictionary) -> Request {
        return request(url, requestType: .GET, parameters: parameters)
    }
    
    func request(url: String, requestType: Alamofire.Method, parameters: NSDictionary) -> Request {
        
        return Alamofire.request(requestType, "http://localhost:3000/api/v0\(url)")
//            .responseJSON { response in
//                switch(response.result) {
//                case .Success(let data):
//                    success(JSON(data))
//                case .Failure(let errorData):
//                    error(errorData)
//                }
//        }
    }
}
