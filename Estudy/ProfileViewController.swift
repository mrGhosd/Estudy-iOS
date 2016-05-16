//
//  ProfileViewController.swift
//  Estudy
//
//  Created by vsokoltsov on 14.05.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//
import UIKit
import Foundation

class ProfileViewController: ApplicationViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var sidebarButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    let textCellIdentifier = "TextCell"
    let headerHeight: CGFloat! = 205
    var user: User!
    
    //MARK: base UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSidebarButton()
        self.setUIForView()
    }
    
    //MARK: Set navigation for viewController
    func setSidebarButton() {
        if self.revealViewController() != nil {
            sidebarButton.target = self.revealViewController()
            sidebarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    //MARK: UITableViewDataSource and UITableViewDElegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 73
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) 
        return cell as UITableViewCell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = NSBundle.mainBundle().loadNibNamed("ProfileInfoView", owner: self, options: nil)[0] as! ProfileInfoView
        view.setUserInformation(user)
        return view as UIView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    //MARK: UI Setup
    func setUIForView() {
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.mainNavigationItemColor
    }
}