//
//  ChatsViewController.swift
//  Estudy
//
//  Created by vsokoltsov on 28.02.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation

class ChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var sidebarButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    var chatsList: [Chat] = []
    let cellIdentifier = "chatsCell"
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}