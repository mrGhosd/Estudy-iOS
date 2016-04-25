//
//  SocketService.swift
//  Estudy
//
//  Created by vsokoltsov on 06.03.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import Foundation
import SocketIOClientSwift

class SocketService: NSObject {
    
    let socket = SocketIOClient(socketURL: NSURL(string: "http://localhost:5001")!)
    
    class var sharedInstance: SocketService {
        struct Singleton {
            static let instance: SocketService = SocketService()
        }
        
        return Singleton.instance
    }
}