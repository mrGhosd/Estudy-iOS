//
//  UsersController.swift
//  Estudy
//
//  Created by vsokoltsov on 03.11.15.
//  Copyright © 2015 vsokoltsov. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

let textCellIdentifier = "TextCell"


class UsersController: ApplicationViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var sidebarButton: UIBarButtonItem!
    var refreshControl: UIRefreshControl!
    var pageNumber = 1
    var searchActive : Bool = false
    var searchedData:[User] = []
    var serverResponse:[User] = []
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "UserListCell", bundle: nil), forCellReuseIdentifier: "TextCell")
        self.searchBar.placeholder = NSLocalizedString("users_search", comment: "")
        self.setupUIRefreshController()
        self.setUIForView()
        self.setSidebarButton()
        self.setupInfinteScrolling()
        self.loadUsersList()
    }
    
    //MARK: Set navigation for viewController
    func setSidebarButton() {
        if self.revealViewController() != nil {
            sidebarButton.target = self.revealViewController()
            sidebarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    //MARK: API requests 
    
    func loadUsersList() {
        self.showProgress()
        UserFactory.getCollection([:], success: successUsersCallback, error: errorUsersCallback)
    }
    
    func loadMoreUsersList() {
        self.showProgress()
        UserFactory.getCollection(["page": pageNumber], success: successLoadMoreUsersCallback, error: errorUsersCallback)
    }
    
    func searchUsers(query: String!) {
        let parameters = ["object": "user", "query": query]
        UserFactory.search(parameters, success: successSearchUsersCallback, error: errorUsersCallback)
    }
    
    //MARK: API request callbacks
    
    func successUsersCallback(objects: [User]){
        refreshControl.endRefreshing()
        self.hideProgress()
        serverResponse = objects
        self.tableView.reloadData()
    }
    
    func successLoadMoreUsersCallback(objects: [User]) {
        self.hideProgress()
        serverResponse += objects
        self.tableView.reloadData()
    }
    
    func successSearchUsersCallback(objects: [User]) {
        searchedData = objects
        self.tableView.reloadData()
    }
    
    func errorUsersCallback(error: ServerError){
        self.hideProgress()
        refreshControl.endRefreshing()
        error.handle(self)
    }
    
    
    //MARK: UITableViewDelegate and UITableViewDataSource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return searchedData.count
        }
        return serverResponse.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 73
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UserListCell
        let row = indexPath.row
        let user: User!
        if(searchActive) {
            user = searchedData[row]
        }
        else {
            user = serverResponse[row]
        }
        cell.setUserData(user)
        return cell as UITableViewCell
    }
    
    //MARK: UI Setup
    func setUIForView() {
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.mainNavigationItemColor
        self.tableView.backgroundColor = Constants.Colors.mainBackgroundColor
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    func setupUIRefreshController() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(UsersController.loadUsersList), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func setupInfinteScrolling() {
        self.tableView.infiniteScrollIndicatorStyle = .White
        self.tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            self.pageNumber += 1
            self.loadMoreUsersList()
            tableView.finishInfiniteScroll()
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
        self.searchUsers(searchText)
    }
    
    //MARK: MBProgressHUD actions
    
    func showProgress() {
        Functions.progressBar.showProgressBar(self.view)
    }
    
    func hideProgress() {
        Functions.progressBar.hideProgressBar(self.view)
    }
    
}
