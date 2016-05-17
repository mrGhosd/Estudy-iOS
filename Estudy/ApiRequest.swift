//
//  ApiRequest.swift
//  Estudy
//
//  Created by vsokoltsov on 17.05.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

class ApiRequest: BaseApiRequest {
    override var host: String! { get { return "http://localhost:3000" } }
    
    class var sharedInstance: ApiRequest {
        struct Singleton {
            static let instance: ApiRequest = ApiRequest()
        }
        
        return Singleton.instance
    }
}