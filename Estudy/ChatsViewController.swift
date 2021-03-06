//
//  ChatsViewController.swift
//  Estudy
//
//  Created by vsokoltsov on 28.02.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation

class ChatsViewController: ApplicationViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet var sidebarButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    var chatsList: [Chat] = []
    var searchedData:[Chat] = []
    var searchActive : Bool = false
    let cellIdentifier = "chatsCell"
    var selectedChat: Chat!
    var refreshControl: UIRefreshControl!
    
    @IBOutlet var searchBar: UISearchBar!
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
        self.showProgress()
        ChatFactory.instance.getCollection(successChatsCallback, error: failureChatCallback)
    }
    
    func searchChats(query: String!) {
        let parameters = ["query": query]
        self.showProgress()
        ChatFactory.search(parameters, success: successSearchCallback, error: failureSearchCallback)
    }
    
    //MARK: API success callbacks
    func successChatsCallback(chats: [Chat]) {
        self.hideProgress()
        refreshControl.endRefreshing()
        chatsList = chats
        tableView.reloadData()
    }
    
    func successSearchCallback(chats: [Chat]) {
        self.hideProgress()
        searchedData = chats
        self.tableView.reloadData()
    }
    
    //MARK: API failure callbacks
    func failureChatCallback(error: ServerError) {
        self.hideProgress()
        refreshControl.endRefreshing()
    }
    
    func failureSearchCallback(error: ServerError) {
        self.hideProgress()
    }
    
    //MARK: UITableViewDelegate and UITableViewDataSource methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ChatCell
        let row = indexPath.row
        let chat = searchActive ? searchedData[row] : chatsList[row]
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
        if (searchActive) {
            return searchedData.count
        }
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
        self.searchBar.placeholder = NSLocalizedString("users_search", comment: "")
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
    
    //MARK: UISearchBarDelegate methods
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.showsCancelButton = true
        self.searchBar.endEditing(true)
        self.searchBar.showsCancelButton = false
        self.searchBar.text = nil
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchChats(searchText)
    }
    
    //MARK: MBProgressHUD actions
    
    func showProgress() {
        Functions.progressBar.showProgressBar(self.view)
    }
    
    func hideProgress() {
        Functions.progressBar.hideProgressBar(self.view)
    }
}