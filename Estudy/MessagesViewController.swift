//
//  MessagesViewController.swift
//  Estudy
//
//  Created by vsokoltsov on 03.03.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import UIKit
import Foundation

class MessagesViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageFormView: UIView!
    var chat: Chat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}