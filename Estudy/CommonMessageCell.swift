//
//  CommonMessageCell.swift
//  Estudy
//
//  Created by vsokoltsov on 22.05.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation

class CommonMessageCell: UITableViewCell {
    var messageText = UILabel()
    var messageUser = UIImageView()
    var cellHeight: CGFloat!
    var imageSize: CGFloat = 50.0
    var currentUserAvatarXCoord: CGFloat!
    var userImageCoordX: CGFloat!
    var messageTextXCoor: CGFloat!
    var messageTextWidth: CGFloat!
    var messageTextheight: CGFloat!
    var currentUser: User! = AuthService.sharedInstance.currentUser
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataToMessageData(messageData: Message!) {
        var user: User! = messageData.user
        var chat: Chat! = messageData.chat
        
        currentUserAvatarXCoord = self.frame.size.width - imageSize - 15
        userImageCoordX = 15.0
        
        
//        messageText.frame = CGRectMake(10.0, 10.0, 200, 14)
        messageText.text = messageData.text
        messageText.numberOfLines = 0
        messageText.lineBreakMode = NSLineBreakMode.ByWordWrapping
        messageText.sizeToFit()
        messageText.backgroundColor = UIColor.whiteColor()
        
        if (user.id == currentUser.id) {
            messageTextXCoor = currentUserAvatarXCoord - 15
            messageUser.frame = CGRectMake(currentUserAvatarXCoord, 10.0, 50, 50)
            messageText.frame = CGRectMake(messageTextXCoor, 10.0, self.frame.size.width - imageSize - 30, messageText.frame.size.height)
        }
        else {
            messageUser.frame = CGRectMake(userImageCoordX, 10.0, 50, 50)
            messageText.frame = CGRectMake(imageSize + 50, 10.0, self.frame.size.width - imageSize - 100, messageText.frame.size.height)
        }
        
        
        cellHeight = messageText.frame.size.height
        var labelSize = messageText.frame.size
        self.addSubview(messageText)
        self.addSubview(messageUser)

        
        Functions.User.avatarImage(messageUser, url: user.avatarUrl)
        
//        self.frame = CGRectMake(0, 0, self.frame.size.width, 1000)
        var cellSize = self.frame.size
        
//        messageText.text = "awdawdaw"
        
    }
    
}
