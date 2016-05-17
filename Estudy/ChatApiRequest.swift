//
//  ChatApiRequest.swift
//  Estudy
//
//  Created by vsokoltsov on 17.05.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import Alamofire
import AlamofireImage
import AlamofireObjectMapper
import KeychainSwift

class ChatApiRequest: BaseApiRequest {
    override var host: String! { get { return "http://localhost:5001" } }
    
    class var sharedInstance: ChatApiRequest {
        struct Singleton {
            static let instance: ChatApiRequest = ChatApiRequest()
        }
        
        return Singleton.instance
    }
}