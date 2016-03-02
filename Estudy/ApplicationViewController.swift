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
import Whisper
import Alamofire
import AlamofireImage

class ApplicationViewController: UIViewController {
    let socket = SocketIOClient(socketURL: NSURL(string: "http://localhost:5001")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentUserReceived:", name: "currentUser", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentUserReceived:", name: "signOut", object: nil)
        setSocketsListener()
    }
    
    func currentUserReceived(notification: NSNotification) {
        setSocketsListener()
    }
    
    func setSocketsListener() {
        if (AuthService.sharedInstance.currentUser != nil) {
            
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
           let message = Mapper<Message>().map(messageData)
//        let message = Mapper<Message>.map(messageData)
        if (UIApplication.sharedApplication().applicationState != UIApplicationState.Active) {
            self.appLocalNotification(message!)
        }
        else {
            var userAvatar: UIImage!
            if let avatarUrl = message!.user.fullAvatarUrl() {
                Alamofire.request(.GET, avatarUrl).responseImage{ response in
                    if let image = response.result.value {
                        userAvatar = image
                        self.appNotification(message, userImage: userAvatar)
                    }
                }
            } else {
                userAvatar = UIImage(named: "empty-user.png")
                self.appNotification(message, userImage: userAvatar)
            }
        }
    }
    
    func appNotification(message: Message!, userImage: UIImage!) {
        let window: UIWindow! = UIApplication.sharedApplication().keyWindow
        let rootVC = window.rootViewController as! SWRevealViewController
        let navVC = rootVC.frontViewController as! UINavigationController
        let topVC = navVC.topViewController!
        let title = message!.user.getCorrectName()
        let text = message!.text
        let announcement = Announcement(title: title, subtitle: text, image: userImage, duration: 3.0)
        Shout(announcement, to: topVC)
    }
    
    func appLocalNotification(message: Message) {
        let notification = UILocalNotification()
        notification.alertTitle = message.user.getCorrectName()
        notification.alertBody = message.text
        notification.fireDate = NSDate(timeIntervalSinceNow: 1)
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["CustomField1": "w00t"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
