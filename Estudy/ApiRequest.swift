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

class ApiRequest: NSObject {
    class var sharedInstance: ApiRequest {
        struct Singleton {
            static let instance: ApiRequest = ApiRequest()
        }
        
        return Singleton.instance
    }
    
    func get(url: String, parameters: NSDictionary, success: (JSON) -> Void, error: (NSError) -> Void){
        Alamofire.request(.GET, url)
                    .responseJSON { response in
                        switch(response.result) {
                        case .Success(let data):
                            success(JSON(data)["users"])
                        case .Failure(let errorData):
                            error(errorData)
                        }
                }
    }
}
