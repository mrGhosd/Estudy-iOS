//
//  MessageCell.swift
//  Estudy
//
//  Created by vsokoltsov on 03.03.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage

class MessageCell: UITableViewCell {
    var message: Message!
    var messageText: UILabel!
    var messageImage: UIImageView!
    
    func setMessageData(messageData: Message!, textField: UILabel!, image: UIImageView!) {
        message = messageData
        messageText = textField
        messageImage = image
        
        messageText.text = message.text
        messageText.lineBreakMode = .ByWordWrapping
        messageText.numberOfLines = 0
        messageText.backgroundColor = UIColor.lightGrayColor()
        messageText.layer.cornerRadius = 25.0
        messageText.sizeToFit()
        Functions.User.avatarImage(messageImage, url: message.user!.fullAvatarUrl())
        self.layoutIfNeeded()
        self.backgroundColor = UIColor.clearColor()
    }
    
    func setPersonalMessageData(messageData: Message, textField: UILabel!) {
        message = messageData
        messageText = textField
        
        messageText.text = message.text
    }
}
