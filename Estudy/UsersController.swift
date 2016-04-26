//
//  UsersController.swift
//  Estudy
//
//  Created by vsokoltsov on 03.11.15.
//  Copyright © 2015 vsokoltsov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

var serverResponse:[User] = []
let textCellIdentifier = "TextCell"

class UsersController: ApplicationViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var sidebarButton: UIBarButtonItem!
    var refreshControl: UIRefreshControl!
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "UserListCell", bundle: nil), forCellReuseIdentifier: "TextCell")
        self.setupUIRefreshController()
        self.setUIForView()
        self.setSidebarButton()
        self.loadUsersList()
    }
    
    //MARK: Set navigation for viewController
    func setSidebarButton() {
        if self.revealViewController() != nil {
            sidebarButton.target = self.revealViewController()
            sidebarButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    //MARK: API requests 
    
    func loadUsersList() {
        UserFactory.getCollection([:], success: successUsersCallback, error: errorUsersCallback)
    }
    
    //MARK: API request callbacks
    
    func successUsersCallback(objects: [User]){
        refreshControl.endRefreshing()
        serverResponse = objects
        self.tableView.reloadData()
    }
    
    func errorUsersCallback(error: ServerError){
        refreshControl.endRefreshing()
        error.handle(self)
    }
    
    
    //MARK: UITableViewDelegate and UITableViewDataSource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverResponse.count
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
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UserListCell
        let row = indexPath.row
        let user = serverResponse[row]
        cell.setUserData(user)
        return cell as UITableViewCell
    }
    
    //MARK: UI Setup
    
    func setUIForView() {
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.mainNavigationItemColor
        self.tableView.backgroundColor = Constants.Colors.mainBackgroundColor
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    func setupUIRefreshController() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "loadUsersList", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
}
