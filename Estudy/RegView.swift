//
//  RegView.swift
//  Estudy
//
//  Created by vsokoltsov on 27.02.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation

class RegView: UIView {
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var passwordConfirmationField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    var delegate: Authorization!
    
    @IBAction func signUp(sender: AnyObject) {
        delegate.signUp!(emailField.text, pasword: passwordField.text, password_confirmation: passwordConfirmationField.text)
    }
}
