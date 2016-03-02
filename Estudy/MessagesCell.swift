//
//  MessagesCell.swift
//  Estudy
//
//  Created by vsokoltsov on 03.03.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage

class MessagesCell: UITableViewCell {
    @IBOutlet var messageCellImage: UIImageView!
    @IBOutlet var messageCellText: UILabel!
    var message: Message!
    
    func setMessageData(messageData: Message) {
        message = messageData
        messageCellText.text = message.text
        setMessageImage()
    }
    
    func setMessageImage() {
        if let avatarUrl = message.user!.fullAvatarUrl() {
            Alamofire.request(.GET, avatarUrl).responseImage{ response in
                if let image = response.result.value {
                    self.messageCellImage.image = image
                }
            }
        } else {
            self.messageCellImage.image = UIImage(named: "empty-user.png")
        }
    }
}
