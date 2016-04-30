//
//  AuthView.swift
//  Estudy
//
//  Created by vsokoltsov on 27.02.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation

class AuthView: UIView {
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var signInButton: UIButton!
    var delegate: Authorization!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        emailField.backgroundColor = UIColor.clearColor()
        emailField.placeholder = NSLocalizedString("email_field", comment: "")
        let str = NSAttributedString(string: NSLocalizedString("email_field", comment: ""), attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        emailField.tintColor = UIColor.whiteColor()
        emailField.textColor = UIColor.whiteColor()
        emailField.attributedPlaceholder = str
        emailField.leftViewMode = UITextFieldViewMode.Always
        emailField.leftView = UIImageView(image: UIImage(named: "email_icon"))
        emailField.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 18.0)
        passwordField.placeholder = NSLocalizedString("password_field", comment: "")
        self.signInButton.setTitle(NSLocalizedString("auth_button", comment: ""), forState: UIControlState.Normal)
    }
    
    @IBAction func signIn(sender: AnyObject) {
        delegate.signIn!(emailField.text, password: passwordField.text)
    }

    
}