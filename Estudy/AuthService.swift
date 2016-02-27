//
//  AuthService.swift
//  Estudy
//
//  Created by vsokoltsov on 27.02.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import Foundation
import KeychainSwift
import Alamofire
import AlamofireObjectMapper

class AuthService: NSObject {
    var keychain = KeychainSwift()
    var currentUser: User!
    
    class var sharedInstance: AuthService {
        struct Singleton {
            static let instance: AuthService = AuthService()
        }
        
        return Singleton.instance
    }
    
    func signIn(email: String!, password: String!, success: (AnyObject) -> Void, error: (ServerError) -> Void) {
        ApiRequest.sharedInstance.post("/sessions", parameters: ["session": ["email": email, "password": password]])
            .responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) in
                switch(response.result) {
                    case .Success(let data):
                        if let token = data["remember_token"] as? String {
                            self.keychain.set(token, forKey: "estudyauthtoken")
                            self.getCurrentUser()
                        }
                    
                    case .Failure(let errorData):
                        let errorValue = ServerError(parameters: errorData)
                        error(errorValue)
                }
        })
    }
    
    func signUp(email: String, password: String!, passwordConfirmation: String!, error: (ServerError) -> Void) {
        ApiRequest.sharedInstance.post("/registrations", parameters: ["user": ["email": email, "password": password, "password_confirmation": passwordConfirmation]])
            .responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) in
                switch(response.result) {
                case .Success(let data):
                    if let token = data["remember_token"] as? String {
                        self.keychain.set(token, forKey: "estudyauthtoken")
                        self.getCurrentUser()
                    }
                    
                case .Failure(let errorData):
                    let errorValue = ServerError(parameters: errorData)
                    error(errorValue)
                }
            })
    }
    
    func getCurrentUser() {
        if (keychain.get("estudyauthtoken") == nil) { return }
        
        ApiRequest.sharedInstance.get("/sessions/current", parameters: [:]).responseObject("user", completionHandler: {(response: Response<User, NSError>) in
            switch(response.result) {
            case .Success(let data):
                self.currentUser = data
                NSNotificationCenter.defaultCenter().postNotificationName("currentUser", object: data)
            default: break
            }
            
        })
    }
    
    func signOut() {
        keychain.delete("estudyauthtoken")
        self.currentUser = nil
        NSNotificationCenter.defaultCenter().postNotificationName("signOut", object: nil)
    }
}