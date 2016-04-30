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
    
    //MARK: Default UIViewController events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ApplicationViewController.currentUserReceived(_:)), name: "currentUser", object: nil)
        self.setupSWRevealViewController()
        self.setupUI()
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: Current User recevieing
    
    override func currentUserReceived(notification: NSNotification) {
        
    }
    
    //MARK: APi requests
    
    func signIn(email: String!, password: String!) {
        AuthService.sharedInstance.signIn(email, password: password, success: successAuthCallback, error: failureAuthCallback)
    }
    
    func signUp(email: String!, pasword: String!, password_confirmation: String!) {
        AuthService.sharedInstance.signUp(email, password: password_confirmation, passwordConfirmation: password_confirmation, error: failureSiegnUpCallback)
    }
    
    //MARK: API callbacks
    
    func successAuthCallback(object: AnyObject!) {
    
    }
    
    func failureAuthCallback(error: ServerError) {
        
    }
    
    func failureSiegnUpCallback(error: ServerError) {
    
    }
    
    
    //MARK: Setup UI for view
    
    func setupSWRevealViewController() {
        if self.revealViewController() != nil {
            sidebarButton.target = self.revealViewController()
            sidebarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    func setupUI() {
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
        
        self.segmentSwitcher.setTitle(NSLocalizedString("auth_auth", comment: ""), forSegmentAtIndex: 0)
        self.segmentSwitcher.setTitle(NSLocalizedString("auth_reg", comment: ""), forSegmentAtIndex: 1)
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.mainNavigationItemColor
    }
    
    //MARK: UI actions
    @IBAction func switchViews(sender: AnyObject) {
        let index = segmentSwitcher.selectedSegmentIndex
        
        if index == 0 {
            authView.hidden = false
            regView.hidden = true
        }
        else if index == 1 {
            authView.hidden = true
            regView.hidden = false
        }
    }
}