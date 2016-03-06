//
//  MessageDelegate.swift
//  Estudy
//
//  Created by vsokoltsov on 06.03.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation

@objc protocol Messages {
    optional func textViewChangeSize(textView: UITextView!)
    optional func createMessage(text: String!)
}