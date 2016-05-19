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
    var refreshControl: UIRefreshControl!
    
    //MARK: UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        setupUI()
        loadChats()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Api requests
    func loadChats() {
        ChatFactory.instance.getCollection(successChatsCallback, error: failureChatCallback)
    }
    
    //MARK: API success callbacks
    func successChatsCallback(chats: [Chat]) {
        refreshControl.endRefreshing()
        chatsList = chats
        tableView.reloadData()
    }
    
    //MARK: API failure callbacks
    func failureChatCallback(error: ServerError) {
        refreshControl.endRefreshing()
    }
    
    //MARK: UITableViewDelegate and UITableViewDataSource methods
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
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("messages", sender: self)
    }
    
    //MARK: Segue navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "messages" {
            let messagesVC = segue.destinationViewController as! MessagesViewController
            messagesVC.chat = selectedChat
            selectedChat = nil
        }
    }
    
    //MARK: UI methods
    
    func setupUI() {
        setNavigationBar()
        setupRefreshControl()
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.mainNavigationItemColor
        self.tableView.backgroundColor = Constants.Colors.mainBackgroundColor
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
    }
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("pull_to_refresh", comment: ""))
        refreshControl.addTarget(self, action: #selector(ChatsViewController.loadChats), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func setNavigationBar() {
        if self.revealViewController() != nil {
            sidebarButton.target = self.revealViewController()
            sidebarButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}