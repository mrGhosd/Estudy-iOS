//
//  ApplicationViewController.swift
//  Estudy
//
//  Created by vsokoltsov on 29.02.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import SocketIOClientSwift
import ObjectMapper

class ApplicationViewController: UIViewController {
        let socket = SocketIOClient(socketURL: NSURL(string: "http://localhost:5001")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentUserReceived:", name: "currentUser", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentUserReceived:", name: "signOut", object: nil)
    }
    
    func currentUserReceived(notification: NSNotification) {
        setSocketsListener()
    }
    
    func setSocketsListener() {
        if (AuthService.sharedInstance.currentUser != nil) {
//            "user\(AuthService.sharedInstance.currentUser.id)chatmessage"
            
            socket.on("connect") {data, ack in
                
                print("socket connected")
            }
            
            socket.on("user\(AuthService.sharedInstance.currentUser.id)chatmessage") {data, ack in
                if let action = data.first!["action"] {
                    switch(String(action!)) {
                    case "chatmessage":
                        if let object = data.first!["obj"] {
                            self.localNotificationForMessage(String(object!))
                        }
                    default: break
                    }
                }
            }
            
            socket.connect()

        }
    }
    
    func localNotificationForMessage(messageData: String) {
        
//        let message = Mapper<Message>.map(messageData)
        let notification = UILocalNotification()
        notification.alertTitle = "Some title"
        notification.alertBody = "New message"
        notification.fireDate = NSDate(timeIntervalSinceNow: 1)
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["CustomField1": "w00t"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}
