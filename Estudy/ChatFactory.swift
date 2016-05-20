//
//  ChatFactory.swift
//  Estudy
//
//  Created by vsokoltsov on 28.02.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireObjectMapper

class ChatFactory: NSObject {
    class var instance: ChatFactory {
        struct Singleton {
            static let instance: ChatFactory = ChatFactory()
        }
        
        return Singleton.instance
    }
    
    func getCollection(success: ([Chat]) -> Void, error: (ServerError) -> Void) {
        ChatApiRequest.sharedInstance.get("/chats", parameters: [:])
            .responseArray("chats", completionHandler: {(response: Response<[Chat], NSError>) in
                switch(response.result) {
                case .Success(let data):
                    success(data)
                case .Failure(let errorData):
                    let errorValue = ServerError(parameters: errorData)
                    error(errorValue)
                }
                
        })
    }
    
    class func search(parameters: NSDictionary, success: ([Chat]) -> Void, error: (ServerError) -> Void) -> Void {
        ApiRequest.sharedInstance.get("/search/chats", parameters: parameters)
            .responseArray("search", completionHandler: { (response: Response<[Chat], NSError>) in
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
