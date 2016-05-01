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
    var params: Dictionary<String, AnyObject>?
    var formErrors: NSDictionary!
    var parentController: UIViewController?
    
    init(parameters: NSError) {
        self.status = parameters.code
        self.desc = parameters.localizedDescription
    }
    
    init(parameters: NSError!, data: NSData!) {
        self.status = parameters.code
        self.desc = parameters.localizedDescription
        do {
            self.params = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! Dictionary<String, AnyObject>
        }
        catch let error as NSError {
            self.params = nil
        }
    }
    
    func handle(view: UIViewController){
        self.parentController = view as UIViewController
        if self.status == -1004{
            showAlertViewWithError()
        }
    }
    
    func showAlertViewWithError(){
        let alert = UIAlertController(title: "Error", message: self.desc, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.parentController!.presentViewController(alert, animated: true, completion: nil)
    }
}