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
        setMessageImage()
    }
    
    func setMessageImage() {
        if let avatarUrl = message.user!.fullAvatarUrl() {
            Alamofire.request(.GET, avatarUrl).responseImage{ response in
                if let image = response.result.value {
                    self.messageImage.image = image
                }
            }
        } else {
            self.messageImage.image = UIImage(named: "empty-user.png")
        }
    }
    
}
