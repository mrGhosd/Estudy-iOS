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
import KeychainSwift


public enum Method: String {
    case GET, HEAD, POST, PUT, PATCH, DELETE
}

class ApiRequest: NSObject {
    var host = "http://localhost:3000"
    var keychain = KeychainSwift()
    
    class var sharedInstance: ApiRequest {
        struct Singleton {
            static let instance: ApiRequest = ApiRequest()
        }
        
        return Singleton.instance
    }
    
    func get(url: String, parameters: NSDictionary) -> Request {
        return request(url, requestType: .GET, parameters: parameters)
    }
    
    func post(url: String, parameters: NSDictionary) -> Request {
        return request(url, requestType: .POST, parameters: parameters)
    }
    
    func request(url: String, requestType: Alamofire.Method, parameters: NSDictionary) -> Request {
        var request: Request!
        let token = keychain.get("estudyauthtoken")
        
        var headers = [
            "Content-Type": "application/json"
        ]
        
        if (token != nil) {
            headers["estudyauthtoken"] = token
        }
        
        if requestType != Alamofire.Method.GET {
            request = Alamofire.request(requestType, "http://localhost:3000/api/v0\(url)", parameters: parameters as? [String : AnyObject], headers: headers, encoding: .JSON)
        }
        else {
            request = Alamofire.request(requestType, "http://localhost:3000/api/v0\(url)", parameters: parameters as? [String : AnyObject], headers: headers)
        }
        
        return request
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
