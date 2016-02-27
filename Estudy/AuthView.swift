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
    
    @IBAction func signIn(sender: AnyObject) {
        delegate.signIn!(emailField.text, password: passwordField.text)
    }

    
}