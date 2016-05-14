//
//  AuthorizationViewController.swift
//  Estudy
//
//  Created by vsokoltsov on 27.02.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation
import MBProgressHUD
import SwiftyVK

class AuthorizationViewController: UIViewController, Authorization, VKDelegate {
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
        VK.start(appID: "5455068", delegate: self)
        self.setupSWRevealViewController()
        self.setupUI()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: Current User recevieing
    
    func currentUserReceived(notification: NSNotification) {
//        self.performSegueWithIdentifier("authorized", sender: self)
    }
    
    //MARK: segue navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let navVC = segue.destinationViewController as! UINavigationController
//        
////        if (segue.identifier == "authorized") {
//            let profileView = navVC.topViewController as! ProfileViewController
////        }
//    }

    
    //MARK: APi requests
    
    func signIn(email: String!, password: String!) {
        self.showProgress()
        AuthService.sharedInstance.signIn(email, password: password, success: successAuthCallback, error: failureAuthCallback)
    }
    
    func signUp(email: String!, password: String!, passwordConfirmation: String!) {
        self.showProgress()
        AuthService.sharedInstance.signUp(email, password: password, passwordConfirmation: passwordConfirmation, success: successAuthCallback, error: failureSignUpCallback)
    }
    
    //MARK: success API callbacks
    
    func successAuthCallback(object: AnyObject!) {
        self.hideProgress()
        self.performSegueWithIdentifier("authorized", sender: self)
    }
    
    //MARK: failure API callbacks
    
    func failureAuthCallback(error: ServerError) {
        self.hideProgress()
        authView.setErrors(error.params!["errors"] as! Dictionary<String, AnyObject>)
    }
    
    func failureSignUpCallback(error: ServerError) {
        self.hideProgress()
        regView.setErrors(error.params!["errors"] as! Dictionary<String, AnyObject>)
    }
    
    func failureVkSignInCallback(error: ServerError) {
        self.hideProgress()
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
    
    @IBAction func vkAuth(sender: AnyObject) {
        VK.autorize()
    }
    
    //MARK: MBProgressHud methods
    
    func showProgress() {
        Functions.progressBar.showProgressBar(self.view)
    }
    
    func hideProgress() {
        Functions.progressBar.hideProgressBar(self.view)
    }
    
    //MARK: VK SDK delegate methods
    
    func vkWillAutorize() -> [VK.Scope] {
        //Called when SwiftyVK need autorization permissions.
        return [VK.Scope.email]//an array of application permissions
    }
    
    func vkDidAutorize(parameters: Dictionary<String, String>) {
        AuthService.sharedInstance.signInViaVK(parameters["email"]!, success: self.successAuthCallback, error: self.failureVkSignInCallback)
        //Called when the user is log in.
        //Here you can start to send requests to the API.
    }

    func vkDidUnautorize() {
        //Called when user is log out.
    }

    func vkAutorizationFailed(error: VK.Error) {
        //Called when SwiftyVK could not authorize. To let the application know that something went wrong.
    }

    func vkTokenPath() -> (useUserDefaults: Bool, alternativePath: String) {
        //Called when SwiftyVK need know where a token is located.
        return (false, "path")//bool value that indicates whether save token to NSUserDefaults or not, and alternative save path.
    }

    func vkWillPresentView() -> UIViewController {
    //Only for iOS!
    //Called when need to display a view from SwiftyVK.
        return self.navigationController!.topViewController!
    }
}

