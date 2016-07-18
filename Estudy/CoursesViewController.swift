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
    
    var serverResponse:[Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "CourseViewCell", bundle: nil), forCellReuseIdentifier: "courseCell")
        tableView.estimatedRowHeight = 1300
        tableView.rowHeight = UITableViewAutomaticDimension
//        self.automaticallyAdjustsScrollViewInsets = false
        loadCoursesList()
    }
    
    //MARK: API requests
    
    func loadCoursesList() {
        CourseFactory.getCollection([:], success: successCoursesLoading, error: failedCourseLoading)
        }
    
    func successCoursesLoading(courses: [Course]) {
        serverResponse = courses
        tableView.reloadData()
    }
    
    func failedCourseLoading(error: ServerError!) {
    
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