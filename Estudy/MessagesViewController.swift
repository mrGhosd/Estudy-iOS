//
//  MessagesViewController.swift
//  Estudy
//
//  Created by vsokoltsov on 03.03.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundatione

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageFormView: UIView!
    var chat: Chat!
    var cellIdentifier = "messageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setContentOffset(CGPoint(x: CGFloat(0), y: CGFloat.max), animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        let message = chat.messages[indexPath.row]
        cell.textLabel!.text = message.text
        return cell as UITableViewCell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.messages.count
    }

}