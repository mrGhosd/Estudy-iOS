//
//  CoursesViewController.swift
//  Estudy
//
//  Created by vsokoltsov on 19.07.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import Foundation

let courseCellIdentifier = "courseCell"

class CoursesViewController: ApplicationViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var sidebarButton: UIBarButtonItem!
    @IBOutlet var searchBar: UISearchBar!
    var pageNumber = 1
    var refreshControl: UIRefreshControl!
    var searchActive = false
    var searchedData:[Course] = []
    var serverResponse:[Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "CourseViewCell", bundle: nil), forCellReuseIdentifier: "courseCell")
        self.searchBar.placeholder = NSLocalizedString("users_search", comment: "")
        tableView.estimatedRowHeight = 1300
        tableView.rowHeight = UITableViewAutomaticDimension
        setSidebarButton()
        setUIForView()
        setupUIRefreshController()
        loadCoursesList()
        
    }
    
    //MARK: Set navigation for viewController
    func setSidebarButton() {
        if self.revealViewController() != nil {
            sidebarButton.target = self.revealViewController()
            sidebarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    //MARK: UI Setup
    func setUIForView() {
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.mainNavigationItemColor
        self.tableView.backgroundColor = Constants.Colors.mainBackgroundColor
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    func setupUIRefreshController() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("pull_to_refresh", comment: ""))
        refreshControl.addTarget(self, action: #selector(CoursesViewController.loadCoursesList), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func setupInfinteScrolling() {
        self.tableView.infiniteScrollIndicatorStyle = .White
        self.tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            self.pageNumber += 1
//            self.loadMoreUsersList()
            tableView.finishInfiniteScroll()
        }
    }
    
    //MARK: API requests
    
    func loadCoursesList() {
        CourseFactory.getCollection([:], success: successCoursesLoading, error: failedCourseLoading)
    }
    
    func loadMoreUsersList() {
        self.showProgress()
//        UserFactory.getCollection(["page": pageNumber], success: successLoadMoreUsersCallback, error: errorUsersCallback)
    }
    
    func searchCourses(query: String!) {
        let parameters = ["object": "course", "query": query]
        CourseFactory.search(parameters, success: successSearchCoursesCallback, error: failedCourseLoading)
    }
    
    
    // API request callbacks
    
    func successCoursesLoading(courses: [Course]) {
        self.refreshControl.endRefreshing()
        serverResponse = courses
        tableView.reloadData()
    }
    
    func failedCourseLoading(error: ServerError!) {
        self.refreshControl.endRefreshing()
    }
    
    func successLoadMoreCoursesCallback(objects: [Course]) {
        self.hideProgress()
        serverResponse += objects
        self.tableView.reloadData()
    }
    
    func successSearchCoursesCallback(objects: [Course]) {
        searchedData = objects
        self.tableView.reloadData()
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
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(courseCellIdentifier, forIndexPath: indexPath) as! CourseViewCell
        let row = indexPath.row
        let course: Course!
        if(searchActive) {
            course = searchedData[row]
        }
        else {
            course = serverResponse[row]
        }
        cell.setCourseDataData(course)
        return cell as UITableViewCell
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
        self.searchCourses(searchText)
    }
    
    //MARK: MBProgressHUD actions
    
    func showProgress() {
        Functions.progressBar.showProgressBar(self.view)
    }
    
    func hideProgress() {
        Functions.progressBar.hideProgressBar(self.view)
    }

}