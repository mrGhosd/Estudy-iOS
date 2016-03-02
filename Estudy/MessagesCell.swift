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

class MessagesCell: MessageCell {
    @IBOutlet var messageCellImage: UIImageView!
    @IBOutlet var messageCellText: UILabel!
    
    func setDataToMessageData(messageData: Message) {
        super.setMessageData(messageData, textField: messageCellText, image: messageCellImage)
    }
}
