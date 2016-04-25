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
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "UserListCell", bundle: nil), forCellReuseIdentifier: "TextCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 142.0/255.0, green: 209.0/255.0, blue: 232.0/255.0, alpha: 1.0)
        self.tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 242.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        if self.revealViewController() != nil {
            sidebarButton.target = self.revealViewController()
            sidebarButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        UserFactory.getCollection([:], success: successUsersCallback, error: errorUsersCallback)

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UserListCell
        let row = indexPath.row
        let user = serverResponse[row]
        cell.setUserData(user)
        return cell as UITableViewCell
    }
    
    func successUsersCallback(objects: [User]){
        serverResponse = objects
        self.tableView.reloadData()
    }
    
    func errorUsersCallback(error: ServerError){
        error.handle(self)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverResponse.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 73;
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
}
