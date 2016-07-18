//
//  CourseTableViewCell.swift
//  Estudy
//
//  Created by vsokoltsov on 19.07.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import Foundation

class CourseViewCell: UITableViewCell {
    
    @IBOutlet var courseImage: UIImageView!
    @IBOutlet var courseTitle: UILabel!
    @IBOutlet var courseShortDescription: UILabel!
    @IBOutlet var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.cardView.alpha = 1.0
//        self.cardView.layer.masksToBounds = false
//        self.cardView.layer.cornerRadius = 1
//        self.cardView.layer.shadowOffset = CGSizeMake(-0.2, -0.2)
//        var path: UIBezierPath = UIBezierPath(roundedRect: self.cardView.bounds, cornerRadius: 1)
//        self.cardView.layer.shadowPath = path.CGPath
//        self.cardView.layer.shadowOpacity = 0.2
//        self.courseTitle.font = Constants.Fonts.usersListNameFont
        
    }
    
    func setCourseDataData(course: Course){
        self.courseTitle.text = course.title;
        self.courseShortDescription.text = course.shortDescription
        Functions.Courses.avatarImage(self.courseImage, url: course.fullImageUrl())
    }
}
