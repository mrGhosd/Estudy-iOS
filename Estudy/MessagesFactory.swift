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

class MessagesFactory: NSObject {
    class var instance: MessagesFactory {
        struct Singleton {
            static let instance: MessagesFactory = MessagesFactory()
        }
        
        return Singleton.instance
    }

}