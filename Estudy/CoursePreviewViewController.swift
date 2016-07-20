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
    var course: Course!
    
    override func viewDidLoad() {
        
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