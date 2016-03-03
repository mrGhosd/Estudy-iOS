//
//  PersonalNavigationBar.swift
//  Estudy
//
//  Created by vsokoltsov on 03.03.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage

class PersonalNavigationBar: UIView {
    @IBOutlet var memberImage: UIImageView!
    @IBOutlet var memberName: UILabel!
    var user: User!

    func setMemberData(member: User) {
        user = member
        memberName.text = user.getCorrectName()
        setMessageImage()
    }
    
    func setMessageImage() {
        if let avatarUrl = user!.fullAvatarUrl() {
            Alamofire.request(.GET, avatarUrl).responseImage{ response in
                if let image = response.result.value {
                    self.memberImage.image = image
                }
            }
        } else {
            self.memberImage.image = UIImage(named: "empty-user.png")
        }
    }
}
