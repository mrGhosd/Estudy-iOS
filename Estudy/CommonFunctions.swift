//
//  CommonFunctions.swift
//  Estudy
//
//  Created by vsokoltsov on 01.05.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import Foundation
import MBProgressHUD

struct Functions {
    struct AuthViews {
        static func customizeTextField(field: UITextField!, placeholder: String!, image: String!) {
            field.backgroundColor = UIColor.clearColor()
            let str = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName:Constants.Colors.authViewPlaceholder])
            field.layer.masksToBounds = true
            field.tintColor = UIColor.whiteColor()
            field.textColor = UIColor.whiteColor()
            field.attributedPlaceholder = str
            field.leftViewMode = UITextFieldViewMode.Always
            field.leftView = UIImageView(image: UIImage(named: image))
            field.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 18.0)
        }
    }
    
    struct progressBar {
        static func showProgressBar(view: UIView!) {
            MBProgressHUD.showHUDAddedTo(view, animated: true)
        }
        
        static func hideProgressBar(view: UIView!) {
            MBProgressHUD.hideAllHUDsForView(view, animated: true)
        }
    }
}