//
//  CurrentUserPersonalMessageCell.swift
//  Estudy
//
//  Created by vsokoltsov on 03.03.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//
import UIKit
import Foundation

class CurrentUserPersonalMessageCell: MessageCell {
    @IBOutlet var messageCellText: UILabel!
    
    func setDataToMessageData(messageData: Message) {
        super.setPersonalMessageData(messageData, textField: messageCellText)
    }
}