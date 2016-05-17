//
//  UserListCell.swift
//  Estudy
//
//  Created by vsokoltsov on 04.11.15.
//  Copyright © 2015 vsokoltsov. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class UserListCell: UITableViewCell {

    @IBOutlet var userAvatar: UIImageView!
    @IBOutlet var fullName: UILabel!
    @IBOutlet var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cardView.alpha = 1.0
        self.cardView.layer.masksToBounds = false
        self.cardView.layer.cornerRadius = 1
        self.cardView.layer.shadowOffset = CGSizeMake(-0.2, -0.2)
        var path: UIBezierPath = UIBezierPath(roundedRect: self.cardView.bounds, cornerRadius: 1)
        self.cardView.layer.shadowPath = path.CGPath
        self.cardView.layer.shadowOpacity = 0.2
        self.fullName.font = Constants.Fonts.usersListNameFont
        
        // Initialization code
    }
    
    func setUserData(user: User){
        self.fullName.text = user.getCorrectName();
        Functions.User.avatarImage(self.userAvatar, url: user.fullAvatarUrl())
    }
}
