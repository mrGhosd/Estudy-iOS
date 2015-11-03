//
//  UsersController.swift
//  Estudy
//
//  Created by vsokoltsov on 03.11.15.
//  Copyright © 2015 vsokoltsov. All rights reserved.
//

import UIKit
import Alamofire
class UsersController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request(.GET, "http://localhost:3000/api/v0/users")
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                let JSON = response.result.value
                if (JSON != nil) {
                    print("JSON: \(JSON)")
                }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
