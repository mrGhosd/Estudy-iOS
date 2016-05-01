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
        Functions.AuthViews.customizeTextField(emailField, placeholder: NSLocalizedString("email_field", comment: ""), image: "email_icon")
        Functions.AuthViews.customizeTextField(passwordField, placeholder: NSLocalizedString("password_field", comment: ""), image: "password_icon")
        self.signInButton.setTitle(NSLocalizedString("auth_button", comment: ""), forState: UIControlState.Normal)
        self.signInButton.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 20.0)!
        self.signInButton.backgroundColor = UIColor(red: 55.0/255.0, green: 240.0/255.0, blue: 132.0/255.0, alpha: 1.0)
        self.signInButton.layer.cornerRadius = 8
    }
    
    @IBAction func signIn(sender: AnyObject) {
        delegate.signIn!(emailField.text, password: passwordField.text)
    }

    
}