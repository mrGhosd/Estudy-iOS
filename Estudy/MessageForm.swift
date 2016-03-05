//
//  MessageForm.swift
//  Estudy
//
//  Created by vsokoltsov on 06.03.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation

class MessageForm: UIView {
    @IBOutlet var messageFormText: UITextView!
    @IBOutlet var messageFormSend: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageFormText.scrollRangeToVisible(NSRange(location: 0,length: 0))
        
        messageFormText.sizeToFit()
    }
    
}