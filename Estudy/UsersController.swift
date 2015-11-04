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

class UsersController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "UserListCell", bundle: nil), forCellReuseIdentifier: "TextCell")
        tableView.delegate = self
        tableView.dataSource = self
        User.getCollection("http://localhost:3000/api/v0/users", parameters: [:], success: successUsersCallback, error: errorUsersCallback)

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
    
    
}
