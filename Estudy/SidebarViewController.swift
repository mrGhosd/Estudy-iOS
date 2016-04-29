//
//  SidebarViewController.swift
//  Estudy
//
//  Created by vsokoltsov on 04.11.15.
//  Copyright © 2015 vsokoltsov. All rights reserved.
//

import UIKit

let sidebarCell = "sidebarCell"
var sideBarMenu: [String]!
let authSideBarMenu = ["Messages"]

class SidebarViewController: ApplicationViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var signOutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentUserReceived:", name: "currentUser", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentUserReceived:", name: "signOut", object: nil)
        self.tableView.backgroundColor = UIColor.clearColor()
        self.view.backgroundColor = Constants.Colors.sidebarBackground
        setSidebarItems()
        
    }
    @IBOutlet var tableView: UITableView!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(sidebarCell, forIndexPath: indexPath)
        let row = sideBarMenu[indexPath.row]
        cell.textLabel?.text = row
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = Constants.Fonts.sidebarItemFont
        return cell
    }
    
    override func currentUserReceived(notification: NSNotification) {
        setSidebarItems()
        self.tableView.reloadData()
    }
    
    func setSidebarItems() {
        if (AuthService.sharedInstance.currentUser != nil) {
            sideBarMenu = ["Profile", "Messages"]
            signOutButton.hidden = false
        }
        else {
           sideBarMenu = [NSLocalizedString("sidebar_sign_in", comment: ""),
                          NSLocalizedString("sidebar_sign_up", comment: ""),
                          NSLocalizedString("sidebar_users", comment: "")]
           signOutButton.hidden = true
        }
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideBarMenu.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch sideBarMenu[indexPath.row] {
            case NSLocalizedString("sidebar_sign_in", comment: ""):
                self.performSegueWithIdentifier("authorization", sender: self)
            case NSLocalizedString("sidebar_sign_up", comment: ""):
                self.performSegueWithIdentifier("registration", sender: self)
            case NSLocalizedString("sidebar_users", comment: ""):
                self.performSegueWithIdentifier("users", sender: self)
            case "Messages":
                self.performSegueWithIdentifier("chats", sender: self)
        default: break
            
            
        }
    }
    
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
            let tableVC = navVC.viewControllers.first as! UsersController
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signOut(sender: AnyObject) {
        AuthService.sharedInstance.signOut()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
