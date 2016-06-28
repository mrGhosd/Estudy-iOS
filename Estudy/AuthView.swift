//
//  AuthView.swift
//  Estudy
//
//  Created by vsokoltsov on 27.02.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation

public class AuthView: UIView {
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var emailErrors: UILabel!
    @IBOutlet var passwordErrors: UILabel!
    
    var delegate: Authorization!
    
    class func init1(nibName: String!) -> AuthView {
        let bundle = NSBundle(forClass: self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view as! AuthView
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        Functions.AuthViews.customizeTextField(emailField, placeholder: NSLocalizedString("email_field", comment: ""), image: "email_icon")
        Functions.AuthViews.customizeTextField(passwordField, placeholder: NSLocalizedString("password_field", comment: ""), image: "password_icon")
        setupUIForButton()
    }
    
    @IBAction func signIn(sender: AnyObject) {
        delegate.signIn!(emailField.text, password: passwordField.text)
    }
    
    func setWidth(width: CGFloat!) {
        Functions.AuthViews.resizeWidth(self, width: width)
    }
    
    func setupUIForButton() {
        self.signInButton.setTitle(NSLocalizedString("auth_button", comment: ""), forState: UIControlState.Normal)
        self.signInButton.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 20.0)!
        self.signInButton.backgroundColor = UIColor(red: 55.0/255.0, green: 240.0/255.0, blue: 132.0/255.0, alpha: 1.0)
        self.signInButton.layer.cornerRadius = 8
    }
    
    func setErrors(errors: Dictionary<String, AnyObject>) {
        self.emailErrors.hidden = true
        self.passwordErrors.hidden = true
        
        if let emailErrorsArr = errors["email"] {
            let errorsArr = emailErrorsArr as! [String]
            var emailError: String! = errorsArr.joinWithSeparator("\n")
            self.emailErrors.text = emailError
            self.emailErrors.hidden = false
        }
        
        if let passwordErrorsArr = errors["password"] {
            let errorsArr = passwordErrorsArr as! [String]
            var passwordError: String! = errorsArr.joinWithSeparator("\n")
            self.passwordErrors.text = passwordError
            self.passwordErrors.hidden = false
        }
    }
    
    func loadViewFromNib(nibName: String!) -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
}