//
//  ChatsViewController.swift
//  Estudy
//
//  Created by vsokoltsov on 28.02.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation

class ChatsViewController: ApplicationViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var sidebarButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    var chatsList: [Chat] = []
    let cellIdentifier = "chatsCell"
    var selectedChat: Chat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        if self.revealViewController() != nil {
            sidebarButton.target = self.revealViewController()
            sidebarButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        ChatFactory.instance.getCollection(successChatsCallback, error: failureChatCallback)
    }
    
    func successChatsCallback(chats: [Chat]) {
        chatsList = chats
        tableView.reloadData()
    }
    
    func failureChatCallback(error: ServerError) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ChatCell
        let row = indexPath.row
        let chat = chatsList[row]
        cell.setCellInfo(chat)
        return cell as UITableViewCell
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatsList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedChat = chatsList[indexPath.row]
        performSegueWithIdentifier("messages", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "messages" {
            let messagesVC = segue.destinationViewController as! MessagesViewController
            messagesVC.chat = selectedChat
            selectedChat = nil
        }
    }
}