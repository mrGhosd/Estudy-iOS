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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func setUserData(user: User){
        self.fullName.text = user.getCorrectName();
        if let avatarUrl = user.fullAvatarUrl() {
            Alamofire.request(.GET, avatarUrl).responseImage{ response in
                if let image = response.result.value {
                    self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.width / 2
                    self.userAvatar.clipsToBounds = true
                    self.userAvatar.layer.borderWidth = 1
                    self.userAvatar.image = image
                }
            }
        } else {
            self.userAvatar.image = UIImage(named: "empty-user.png")
        }
    }
}
