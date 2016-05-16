//
//  ProfileInfoView.swift
//  Estudy
//
//  Created by vsokoltsov on 16.05.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class ProfileInfoView: UIView {
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var userAvatar: UIImageView!
    @IBOutlet var userName: UILabel!
    
    func setUserInformation(user: User!) {
        self.userName.text = user.getCorrectName()
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
        
        var randomRed:CGFloat = CGFloat(drand48())
        
        var randomGreen:CGFloat = CGFloat(drand48())
        
        var randomBlue:CGFloat = CGFloat(drand48())
        
        self.backgroundImage.backgroundColor = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 0.5)
    }
}