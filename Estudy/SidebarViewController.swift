//
//  SidebarViewController.swift
//  Estudy
//
//  Created by vsokoltsov on 04.11.15.
//  Copyright © 2015 vsokoltsov. All rights reserved.
//

import UIKit

let sidebarCell = "sidebarCell"
var sideBarMenu: [[String: String]]!
let authSideBarMenu = ["Messages"]

class SidebarViewController: ApplicationViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var signOutButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    
    //MARK: default UIViewController actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ApplicationViewController.currentUserReceived(_:)), name: "currentUser", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ApplicationViewController.currentUserReceived(_:)), name: "signOut", object: nil)
        self.tableView.backgroundColor = UIColor.clearColor()
        self.view.backgroundColor = Constants.Colors.sidebarBackground
        setSidebarItems()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: UITableViewDelegates and UITableViewDataSource methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(sidebarCell, forIndexPath: indexPath)
        let row = sideBarMenu[indexPath.row]
        cell.textLabel?.text = row["title"] as String!
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = Constants.Fonts.sidebarItemFont
        cell.imageView!.image = UIImage(named: row["icon"] as String!)
        return cell
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideBarMenu.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var title = sideBarMenu[indexPath.row]["title"] as String!
        let currentUser = AuthService.sharedInstance.currentUser
        
        switch title {
            case NSLocalizedString("sidebar_sign_in", comment: ""):
                self.performSegueWithIdentifier("authorization", sender: self)
            case NSLocalizedString("sidebar_sign_up", comment: ""):
                self.performSegueWithIdentifier("registration", sender: self)
            case NSLocalizedString("sidebar_users", comment: ""):
                self.performSegueWithIdentifier("users", sender: self)
            case currentUser.getCorrectName():
                self.performSegueWithIdentifier("profile", sender: self)
            case "Messages":
                self.performSegueWithIdentifier("chats", sender: self)
        default: break
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: UIViewController actions
    
    @IBAction func signOut(sender: AnyObject) {
        AuthService.sharedInstance.signOut()
    }
    
    //MARK: Current user actions
    override func currentUserReceived(notification: NSNotification) {
        setSidebarItems()
        self.tableView.reloadData()
    }
    
    //MARK: Segue Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navVC = segue.destinationViewController as! UINavigationController
        if segue.identifier == "authorization" {
            let tableVC = navVC.viewControllers.first as! AuthorizationViewController
            tableVC.isAuth = true
        }
        
        if (segue.identifier == "registration") {
            let tableVC = navVC.viewControllers.first as! AuthorizationViewController
            tableVC.isAuth = false
        }
        
        if (segue.identifier == "users") {
            _ = navVC.viewControllers.first as! UsersController
        }
        
        if (segue.identifier == "profile") {
            let profileView = navVC.viewControllers.first as! ProfileViewController
            profileView.user = AuthService.sharedInstance.currentUser
        }
    }
    
    //MARK: UI setup methods
    func setSidebarItems() {
        let currentUser = AuthService.sharedInstance.currentUser
        if (currentUser != nil) {
            sideBarMenu = [
                ["icon": "profile_icon", "title": currentUser.getCorrectName()],
                ["icon": "messages_icon", "title": "Messages"],
                ["icon": "users_icon", "title": NSLocalizedString("sidebar_users", comment: "")]
            ]
            signOutButton.hidden = false
        }
        else {
            sideBarMenu = [
                ["icon": "sign_in_icon", "title": NSLocalizedString("sidebar_sign_in", comment: "")],
                ["icon": "sign_up_icon", "title":  NSLocalizedString("sidebar_sign_up", comment: "")],
                ["icon": "users_icon", "title": NSLocalizedString("sidebar_users", comment: "")]
            ]
            signOutButton.hidden = true
        }
    }
    
    
}
