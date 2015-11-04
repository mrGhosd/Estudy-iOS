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
    
    func get(url: String, parameters: NSDictionary, success: (JSON) -> Void, error: (JSON) -> Void){
        Alamofire.request(.GET, url)
                    .responseJSON { response in
                        if let data = response.result.value{
                            success(JSON(data))
                        }
//                        var jsonData = JSON(response.result.value!)
//                        for user in jsonData["users"]{
//                            let newUser = User(parameters: user.1)
//                            serverResponse.append(newUser)
//                        }
//                        self.tableView.reloadData()
                        
                }
    }
}
