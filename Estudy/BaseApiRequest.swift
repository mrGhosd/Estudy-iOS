//
//  BaseApiRequest.swift
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

class BaseApiRequest: NSObject {
    var host: String! { get { return nil } }
    var keychain = KeychainSwift()
    
    func get(url: String, parameters: NSDictionary) -> Request {
        return request(url, requestType: .GET, parameters: parameters)
    }
    
    func post(url: String, parameters: NSDictionary) -> Request {
        return request(url, requestType: .POST, parameters: parameters)
    }
    
    func request(url: String, requestType: Alamofire.Method, parameters: NSDictionary) -> Request {
        var request: Request!
        let token = keychain.get("estudyauthtoken")
        let currentLocale = NSLocale.preferredLanguages().first
        let rangeOfHello = currentLocale?.startIndex.advancedBy(2)
        
        var headers = [
            "Content-Type": "application/json",
            "locale": currentLocale!.substringToIndex(rangeOfHello!)
        ]
        
        if (token != nil) {
            headers["estudyauthtoken"] = token
        }
        
        if requestType != Alamofire.Method.GET {
            request = Alamofire.request(requestType, "\(host)/api/v0\(url)", parameters: parameters as? [String : AnyObject], headers: headers, encoding: .JSON)
        }
        else {
            request = Alamofire.request(requestType, "\(host)/api/v0\(url)", parameters: parameters as? [String : AnyObject], headers: headers)
        }
        
        return request.validate()
    }
}
