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
import SwiftyJSON

let env = NSProcessInfo.processInfo().environment

class ApiRequest {
    class var sharedInstance: ApiRequest{
        let env = NSProcessInfo.processInfo().environment
        let API_HOST = env["API_HOST"]
        struct Singleton{
            static let instance: ApiRequest = ApiRequest()
        }
        return Singleton.instance
    }
    
    func get(url: String, parameters: NSDictionary, success: (JSON) -> Void, error: (JSON) -> Void) -> Void{
        Alamofire.request(.GET, url, parameters: parameters as! [String : AnyObject])
            .responseJSON { response in
                if let data = response.result.value{
                    success(JSON(data))
                } else {
//                    error(JSON(response))
                }
//                if let data = JSON(response.result.value!)
//                for user in jsonData["users"]{
//                    let newUser = User(parameters: user.1)
//                    serverResponse.append(newUser)
//                }
                
        }
    }
}
