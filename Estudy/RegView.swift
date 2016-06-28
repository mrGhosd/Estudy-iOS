//
//  RegView.swift
//  Estudy
//
//  Created by vsokoltsov on 27.02.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation

public class RegView: UIView {
    @IBOutlet var emailField: UITextField!
    @IBOutlet var emailError: UILabel!
    
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var passwordError: UILabel!
    
    @IBOutlet var passwordConfirmationField: UITextField!
    @IBOutlet var passwordConfirmationError: UILabel!
    
    @IBOutlet var signUpButton: UIButton!
    var delegate: Authorization!
    
    class func init1(nibName: String!) -> RegView {
        let bundle = NSBundle(forClass: self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view as! RegView
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        Functions.AuthViews.customizeTextField(emailField, placeholder: NSLocalizedString("email_field", comment: ""), image: "email_icon")
        Functions.AuthViews.customizeTextField(passwordField, placeholder: NSLocalizedString("password_field", comment: ""), image: "password_icon")
        Functions.AuthViews.customizeTextField(passwordConfirmationField, placeholder: NSLocalizedString("password_confirmation_field", comment: ""), image: "password_icon")
        setupUIForButton()
    }
    
    @IBAction func signUp(sender: AnyObject) {
        delegate.signUp!(emailField.text, password: passwordField.text, passwordConfirmation: passwordConfirmationField.text)
    }
    
    func setWidth(width: CGFloat!) {
        Functions.AuthViews.resizeWidth(self, width: width)
    }
    
    func setupUIForButton() {
        self.signUpButton.setTitle(NSLocalizedString("reg_button", comment: ""), forState: UIControlState.Normal)
        self.signUpButton.titleLabel!.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 20.0)!
        self.signUpButton.backgroundColor = UIColor(red: 55.0/255.0, green: 240.0/255.0, blue: 132.0/255.0, alpha: 1.0)
        self.signUpButton.layer.cornerRadius = 8
    }
    
    func setErrors(errors: Dictionary<String, AnyObject>) {
        self.emailError.hidden = true
        self.passwordError.hidden = true
        self.passwordConfirmationError.hidden = true
        
        if let emailErrorsArr = errors["email"] {
            let errorsArr = emailErrorsArr as! [String]
            var emailError: String! = errorsArr.joinWithSeparator("\n")
            self.emailError.text = emailError
            self.emailError.hidden = false
        }
        
        if let passwordErrorsArr = errors["password"] {
            let errorsArr = passwordErrorsArr as! [String]
            var passwordError: String! = errorsArr.joinWithSeparator("\n")
            self.passwordError.text = passwordError
            self.passwordError.hidden = false
        }
        
        if let passwordConfirmationErrorsArr = errors["password_confirmation"] {
            let errorsArr = passwordConfirmationErrorsArr as! [String]
            let passwordConfirmationError: String! = errorsArr.joinWithSeparator("\n")
            self.passwordConfirmationError.text = passwordConfirmationError
            self.passwordConfirmationError.hidden = false
        }
    }
}
