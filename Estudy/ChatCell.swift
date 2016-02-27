//
//  ChatCell.swift
//  Estudy
//
//  Created by vsokoltsov on 28.02.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage

class ChatCell: UITableViewCell {
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var membersNames: UILabel!
    @IBOutlet var chatCreatedAt: UILabel!
    @IBOutlet var lastMessage: UILabel!
    var chatData: Chat?
    
    func setCellInfo(chat: Chat) {
        chatData = chat
        setChatMembers()
        setChatImage()
        setLastMessage()
        setLastMessageTime()
    }
    
    func setChatMembers() {
        var members: [String] = []
        for user in chatData!.users! {
            let name = user.getCorrectName()
            if (AuthService.sharedInstance.currentUser.getCorrectName() != name) {
                members.insert(name, atIndex: 0)
            }
        }
        self.membersNames.text = members.joinWithSeparator(", ")
    }
    
    func setChatImage() {
        let usersList = chatData!.users!.filter { (user) in user.getCorrectName() != AuthService.sharedInstance.currentUser.getCorrectName() }
        let user = usersList.first
        
        if let avatarUrl = user!.fullAvatarUrl() {
            Alamofire.request(.GET, avatarUrl).responseImage{ response in
                if let image = response.result.value {
                    self.userImage.image = image
                }
            }
        } else {
            self.userImage.image = UIImage(named: "empty-user.png")
        }
        
    }
    
    func setLastMessage() {
        let message = chatData!.messages!.last
        self.lastMessage.text = message!.text
    }
    
    func setLastMessageTime() {
        let message = chatData!.messages!.last
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        let dateString = formatter.stringFromDate(message!.createdAt)
        self.chatCreatedAt.text = dateString
    }
    
}