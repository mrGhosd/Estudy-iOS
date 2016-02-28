//
//  AuthorizationViewController.swift
//  Estudy
//
//  Created by vsokoltsov on 27.02.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation

class AuthorizationViewController: ApplicationViewController, Authorization {
    @IBOutlet var segmentSwitcher: UISegmentedControl!
    @IBOutlet var sidebarButton: UIBarButtonItem!
    @IBOutlet var contentView: UIView!
    var isAuth: Bool! = true
    var authView: AuthView!
    var regView: RegView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentUserReceived:", name: "currentUser", object: nil)
        if self.revealViewController() != nil {
            sidebarButton.target = self.revealViewController()
            sidebarButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        authView = NSBundle.mainBundle().loadNibNamed("AuthView", owner: self, options: nil).first as! AuthView
        authView.delegate = self
        contentView.addSubview(authView)
        regView = NSBundle.mainBundle().loadNibNamed("RegView", owner: self, options: nil).first as! RegView
        regView.delegate = self
        contentView.addSubview(regView)
        
        if isAuth == true {
            segmentSwitcher.selectedSegmentIndex = 0
            authView.hidden = false
            regView.hidden = true
        }
        else {
            segmentSwitcher.selectedSegmentIndex = 1
            authView.hidden = true
            regView.hidden = false
        }
    }
    
    func currentUserReceived(notification: NSNotification) {
        
    }
    
    @IBAction func switchViews(sender: AnyObject) {
        var index = segmentSwitcher.selectedSegmentIndex
        
        if index == 0 {
            authView.hidden = false
            regView.hidden = true
        }
        else if index == 1 {
            authView.hidden = true
            regView.hidden = false
        }
    }
    
    func signIn(email: String!, password: String!) {
        AuthService.sharedInstance.signIn(email, password: password, success: successAuthCallback, error: failureAuthCallback)
    }
    
    func signUp(email: String!, pasword: String!, password_confirmation: String!) {
        AuthService.sharedInstance.signUp(email, password: password_confirmation, passwordConfirmation: password_confirmation, error: failureSiegnUpCallback)
    }
    
    func successAuthCallback(object: AnyObject!) {
    
    }
    
    func failureAuthCallback(error: ServerError) {
        
    }
    
    func failureSiegnUpCallback(error: ServerError) {
    
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}