//
//  MessagesFactory.swift
//  Estudy
//
//  Created by vsokoltsov on 03.03.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class MessagesFactory: NSObject {
    class var sharedInstance: MessagesFactory {
        struct Singleton {
            static let sharedInstance: MessagesFactory = MessagesFactory()
        }
        
        return Singleton.sharedInstance
    }
    
    func create(parameters: NSDictionary, success: (Message) -> Void, error: (ServerError) -> Void) {
        ApiRequest.sharedInstance.post("/messages", parameters: parameters)
            .responseObject("message", completionHandler: {(response: Response<Message, NSError>) in
                switch(response.result) {
                case .Success(let data):
                    success(data)
                case .Failure(let errorData):
                    let errorValue = ServerError(parameters: errorData)
                    error(errorValue)
                }
            })
    }
    
    func parseObject(message: String!) -> Message {
        return Mapper<Message>().map(message)!
    }

}