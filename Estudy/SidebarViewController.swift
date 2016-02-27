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

class SidebarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentUserReceived:", name: "currentUser", object: nil)
        setSidebarItems()
        
    }
    @IBOutlet var tableView: UITableView!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(sidebarCell, forIndexPath: indexPath)
        let row = sideBarMenu[indexPath.row]
        cell.textLabel?.text = row
        return cell
    }
    
    func currentUserReceived(notification: NSNotification) {
        setSidebarItems()
        self.tableView.reloadData()
    }
    
    func setSidebarItems() {
        if (AuthService.sharedInstance.currentUser != nil) {
            sideBarMenu = ["Profile", "Messages"]
        }
        else {
           sideBarMenu = ["Sign in", "Sign up"]
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
            case "Sign in":
                self.performSegueWithIdentifier("authorization", sender: self)
            case "Sign up":
                self.performSegueWithIdentifier("registration", sender: self)
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
