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

var serverResponse:JSON = []
let textCellIdentifier = "TextCell"

class UsersController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        Alamofire.request(.GET, "http://localhost:3000/api/v0/users")
            .responseJSON { response in
                var jsonData = JSON(response.result.value!)
                serverResponse = jsonData["users"]
                self.tableView.reloadData()
                
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        let element = serverResponse[row]
        cell.textLabel?.text = element["email"].stringValue
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverResponse.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
