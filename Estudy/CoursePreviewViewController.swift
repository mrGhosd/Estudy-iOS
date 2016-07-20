//
//  CoursePreviewViewController.swift
//  Estudy
//
//  Created by vsokoltsov on 20.07.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//
import UIKit
import Foundation

class CoursePreviewViewController: UIViewController {
    @IBOutlet var courseImage: UIImageView!
    @IBOutlet var courseTitle: UILabel!
    @IBOutlet var courseShortDescription: UILabel!
    var course: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Functions.Courses.avatarImage(courseImage, url: course.fullImageUrl())
        courseTitle.text = course.title
        courseShortDescription.text = course.shortDescription
    }
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        
        let likeAction = UIPreviewAction(title: "Like", style: .Default) { (action, viewController) -> Void in
            print("You liked the photo")
        }
        
        let deleteAction = UIPreviewAction(title: "Delete", style: .Destructive) { (action, viewController) -> Void in
            print("You deleted the photo")
        }
        
        return [likeAction, deleteAction]
    }
}