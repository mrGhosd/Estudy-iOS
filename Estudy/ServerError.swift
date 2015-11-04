//
//  ServerError.swift
//  Estudy
//
//  Created by vsokoltsov on 04.11.15.
//  Copyright © 2015 vsokoltsov. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ServerError: NSObject {
    var desc: String = ""
    var status: Int = 0
    var parentController: UIViewController?
    
    init(parameters: NSError) {
        self.status = parameters.code
        self.desc = parameters.localizedDescription
    }
    
    func handle(view: UIViewController){
        self.parentController = view as UIViewController
        if self.status == -1004{
            showAlertViewWithError()
        }
    }
    
    func showAlertViewWithError(){
        let alert = UIAlertController(title: "Error", message: self.desc, preferredStyle: UIAlertControllerStyle.Alert)
        self.parentController!.presentViewController(alert, animated: true, completion: nil)
    }
}