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
    @IBOutlet var userEmail: UILabel!
    @IBOutlet var fullName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func setUserData(user: User){
        self.userEmail.text = user.email
        if let avatarUrl = user.avatarUrl{
            Alamofire.request(.GET, avatarUrl).responseImage{ response in
                if let image = response.result.value {
                    self.userAvatar.image = image
                }
            }
        } else {
            self.userAvatar.image = UIImage(named: "empty-user.png")
        }
    }
}
