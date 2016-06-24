//
//  CommonFunctions.swift
//  Estudy
//
//  Created by vsokoltsov on 01.05.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import Foundation
import MBProgressHUD
import Alamofire

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
    
    struct UserF {
        static func avatarImage(imageView: UIImageView!, url: String?) {
            if let avatarUrl =  url {
                Alamofire.request(.GET, avatarUrl).responseImage{ response in
                    if let image = response.result.value {
                        imageView.layer.cornerRadius = imageView.frame.size.width / 2
                        imageView.clipsToBounds = true
                        imageView.layer.borderWidth = 1
                        imageView.image = image
                    }
                }
            } else {
                imageView.image = UIImage(named: "empty-user.png")
            }
        }
    }
    
    struct Sidebar {
        static func initTableVIew(controller: UIViewController!, view: UIView!, tableView: UITableView!) {
            NSNotificationCenter.defaultCenter().addObserver(controller, selector: #selector(ApplicationViewController.currentUserReceived(_:)), name: "currentUser", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(controller, selector: #selector(ApplicationViewController.currentUserReceived(_:)), name: "signOut", object: nil)
            tableView.backgroundColor = UIColor.clearColor()
            view.backgroundColor = Constants.Colors.sidebarBackground
        }
        
        static func cellConfig(identifier: String!, indexPath: NSIndexPath!, items: [[String: String]]!, tableView: UITableView!) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
            let row = items[indexPath.row]
            cell.textLabel?.text = row["title"] as String!
            cell.backgroundColor = UIColor.clearColor()
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.textLabel?.font = Constants.Fonts.sidebarItemFont
            cell.imageView!.image = UIImage(named: row["icon"] as String!)
            return cell
        }
        
        static func setSidebarItems(currentUser: User!, sidebarMenu: [[String: String]]!, signOutButton: UIButton!) ->  [[String: String]]! {
            if (currentUser != nil) {
                sideBarMenu = [
                    ["icon": "profile_icon", "title": currentUser.getCorrectName()],
                    ["icon": "messages_icon", "title": "Messages"],
                    ["icon": "users_icon", "title": NSLocalizedString("sidebar_users", comment: "")]
                ]
                signOutButton.hidden = false
            }
            else {
                sideBarMenu = [
                    ["icon": "sign_in_icon", "title": NSLocalizedString("sidebar_sign_in", comment: "")],
                    ["icon": "sign_up_icon", "title":  NSLocalizedString("sidebar_sign_up", comment: "")],
                    ["icon": "users_icon", "title": NSLocalizedString("sidebar_users", comment: "")]
                ]
                signOutButton.hidden = true
            }
            
            return sideBarMenu
        }
    }
    
    struct Device {
        static func isIPad() -> Bool {
            return  UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        }
        
        static func isIphone() -> Bool {
            return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        }
    }
}