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
    var personalCellIdentifier = "personalCellIdentifier"
    var currentUserPersonalCellIdentifier = "currentUserPersonalCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarData()
        tableView.setContentOffset(CGPoint(x: CGFloat(0), y: CGFloat.max), animated: true)
        tableView.registerNib(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.registerNib(UINib(nibName: "CurrentUserMessageCell", bundle: nil), forCellReuseIdentifier: currentUserCellIdentifier)
        tableView.registerNib(UINib(nibName: "PersonalMessageCell", bundle: nil), forCellReuseIdentifier: personalCellIdentifier)
        tableView.registerNib(UINib(nibName: "CurrentUserPersonalMessageCell", bundle: nil), forCellReuseIdentifier: currentUserPersonalCellIdentifier)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = chat.messages[indexPath.row]
        if (hasMultipleUsers()) {
            if (message.user.id == AuthService.sharedInstance.currentUser.id) {
                return currentUserMessageCellInstance(message, indexPath: indexPath) as UITableViewCell
            }
            else {
                return messageCellInstance(message, indexPath: indexPath) as UITableViewCell
            }
        }
        else {
            if (message.user.id == AuthService.sharedInstance.currentUser.id) {
                return currentUserPersonalMessageCellInstance(message, indexPath: indexPath) as UITableViewCell
            }
            else {
                return personalMessageCellInstance(message, indexPath: indexPath) as UITableViewCell
            }
        }
        
        
    }
    
    func currentUserMessageCellInstance(message: Message, indexPath: NSIndexPath) -> CurrentUserMessageCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(currentUserCellIdentifier, forIndexPath: indexPath) as! CurrentUserMessageCell
        cell.setDataToMessageData(message)
        return cell
    }
    
    func messageCellInstance(message: Message, indexPath: NSIndexPath) -> MessageCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MessagesCell
        cell.setDataToMessageData(message)
        return cell
    }
    
    func personalMessageCellInstance(message: Message, indexPath: NSIndexPath) -> PersonalMessageCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(personalCellIdentifier, forIndexPath: indexPath) as! PersonalMessageCell
        cell.setDataToMessageData(message)
        return cell
    }
    
    func currentUserPersonalMessageCellInstance(message: Message, indexPath: NSIndexPath) -> CurrentUserPersonalMessageCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(currentUserPersonalCellIdentifier, forIndexPath: indexPath) as! CurrentUserPersonalMessageCell
        cell.setDataToMessageData(message)
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (hasMultipleUsers()) {
            return 90
        }
        else {
            return 50
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.messages.count
    }
    
    func hasMultipleUsers() -> Bool {
        return chat.users!.count > 2
    }
    
    func setNavigationBarData() {
        if (!hasMultipleUsers()) {
            let view = NSBundle.mainBundle().loadNibNamed("PersonalNavigationBar", owner: nil, options: nil).first as! PersonalNavigationBar
            var member = returnOtherChatMembers().first as! User!
            view.setMemberData(member)
            self.navigationItem.titleView = view
        }
    }
    
    func returnOtherChatMembers() -> [User] {
        return (chat.users?.filter({ $0.id != AuthService.sharedInstance.currentUser.id }))!
    }

}