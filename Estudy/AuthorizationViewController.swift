//
//  AuthorizationViewController.swift
//  Estudy
//
//  Created by vsokoltsov on 27.02.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation

class AuthorizationViewController: UIViewController {
    @IBOutlet var segmentSwitcher: UISegmentedControl!
    @IBOutlet var sidebarButton: UIBarButtonItem!
    @IBOutlet var contentView: UIView!
    var isAuth: Bool! = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            sidebarButton.target = self.revealViewController()
            sidebarButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        if isAuth == true {
            segmentSwitcher.selectedSegmentIndex = 0
        }
        else {
            segmentSwitcher.selectedSegmentIndex = 1
        }
    }
}