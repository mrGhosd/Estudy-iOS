//
//  CoursesViewController.swift
//  Estudy
//
//  Created by vsokoltsov on 19.07.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import Foundation

let courseCellIdentifier = "courseCell"

class CoursesViewController: ApplicationViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIViewControllerPreviewingDelegate {
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
        if traitCollection.forceTouchCapability == .Available {
            self.registerForPreviewingWithDelegate(self, sourceView: view)
        }
        tableView.estimatedRowHeight = 150
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
            self.loadMoreCourses()
            tableView.finishInfiniteScroll()
        }
    }
    
    //MARK: API requests
    
    func loadCoursesList() {
        self.showProgress()
        CourseFactory.getCollection([:], success: successCoursesLoading, error: failedCourseLoading)
    }
    
    func loadMoreCourses() {
        self.showProgress()
        self.showProgress()
        CourseFactory.getCollection(["page": pageNumber], success: successLoadMoreCoursesCallback, error: failedCourseLoading)
    }
    
    func searchCourses(query: String!) {
        let parameters = ["object": "course", "query": query]
        CourseFactory.search(parameters, success: successSearchCoursesCallback, error: failedCourseLoading)
    }
    
    
    // API request callbacks
    
    func successCoursesLoading(courses: [Course]) {
        self.refreshControl.endRefreshing()
        self.hideProgress()
        serverResponse = courses
        tableView.reloadData()
    }
    
    func failedCourseLoading(error: ServerError!) {
        self.refreshControl.endRefreshing()
        self.hideProgress()
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
    
    //MARK: UIViewControllerPreviewDelegate methods
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        var contentHeight = 300.0
        
        let indexPath = tableView.indexPathForRowAtPoint(location)
        let cell = tableView.cellForRowAtIndexPath(indexPath!)
        let detailVC = storyboard?.instantiateViewControllerWithIdentifier("CoursePreview") as! CoursePreviewViewController
        let course = serverResponse[indexPath!.row]
        
        var text = course.shortDescription as! NSString
        var size = text.boundingRectWithSize(CGSizeMake(200, 0), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: ["NSFontAttributeName": UIFont.systemFontOfSize(16.0)], context: nil)
        if size.height > 50 {
            contentHeight = contentHeight + Double(size.height)
        }
        detailVC.course = course
        detailVC.preferredContentSize = CGSize(width: 0.0, height: Double(contentHeight))
        
        previewingContext.sourceRect = cell!.frame
        
        return detailVC
        
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        showViewController(viewControllerToCommit, sender: self)
        
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