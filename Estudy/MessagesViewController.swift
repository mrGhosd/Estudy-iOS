//
//  MessagesViewController.swift
//  Estudy
//
//  Created by vsokoltsov on 03.03.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageFormView: UIView!
    var chat: Chat!
    var cellIdentifier = "messageCell"
    var currentUserCellIdentifier = "currentUserMessageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setContentOffset(CGPoint(x: CGFloat(0), y: CGFloat.max), animated: true)
        tableView.registerNib(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
                tableView.registerNib(UINib(nibName: "CurrentUserMessageCell", bundle: nil), forCellReuseIdentifier: currentUserCellIdentifier)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = chat.messages[indexPath.row]
        if (message.user.id == AuthService.sharedInstance.currentUser.id) {
            var cell = tableView.dequeueReusableCellWithIdentifier(currentUserCellIdentifier, forIndexPath: indexPath) as! CurrentUserMessageCell
            cell.setDataToMessageData(message)
            return cell as UITableViewCell
        }
        else {
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MessagesCell
            cell.setDataToMessageData(message)
            return cell as UITableViewCell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.messages.count
    }

}