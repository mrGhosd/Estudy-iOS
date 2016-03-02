//
//  CurrentUserMessageCell.swift
//  Estudy
//
//  Created by vsokoltsov on 03.03.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage


class CurrentUserMessageCell: UITableViewCell {
    @IBOutlet var messageImage: UIImageView!
    @IBOutlet var messageText: UILabel!
    var message: Message!
    
    func setMessageData(messageData: Message) {
        message = messageData
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