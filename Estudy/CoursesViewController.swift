//
//  CoursesViewController.swift
//  Estudy
//
//  Created by vsokoltsov on 19.07.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import Foundation

let courseCellIdentifier = "courseCell"

class CoursesViewController: ApplicationViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var sidebarButton: UIBarButtonItem!
    var pageNumber = 1
    var refreshControl: UIRefreshControl!
    
    var serverResponse:[Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "CourseViewCell", bundle: nil), forCellReuseIdentifier: "courseCell")
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
    
    func successCoursesLoading(courses: [Course]) {
        self.refreshControl.endRefreshing()
        serverResponse = courses
        tableView.reloadData()
    }
    
    func failedCourseLoading(error: ServerError!) {
        self.refreshControl.endRefreshing()
    }
    
    //MARK: UITableViewDelegate and UITableViewDataSource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 73
//    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(courseCellIdentifier, forIndexPath: indexPath) as! CourseViewCell
        let row = indexPath.row
        let course: Course!
        course = serverResponse[row]
        cell.setCourseDataData(course)
        return cell as UITableViewCell
    }

}