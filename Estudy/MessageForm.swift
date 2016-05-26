//
//  MessageForm.swift
//  Estudy
//
//  Created by vsokoltsov on 06.03.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation

class MessageForm: UIView, UITextViewDelegate {
    @IBOutlet var messageFormText: UITextView!
    @IBOutlet var messageFormSend: UIButton!
    var delegate: Messages!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageFormText.delegate = self
        messageFormText.setContentOffset(CGPointMake(0, 0), animated: false)
        messageFormText.layer.cornerRadius = 8.0
    }
    
    func textViewDidChange(textView: UITextView) {
        delegate.textViewChangeSize!(messageFormText)
    }
    
    @IBAction func sendMessage(sender: AnyObject) {
        delegate.createMessage!(messageFormText.text)
    }
    
    public func resetFormText() {
        messageFormText.text = ""
    }
    
}