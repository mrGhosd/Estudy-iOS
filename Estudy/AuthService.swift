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
    
    let defaultProvider = "Estudy"
    let vkProvider = "Vkontakte"
    
    class var sharedInstance: AuthService {
        struct Singleton {
            static let instance: AuthService = AuthService()
        }
        
        return Singleton.instance
    }
    
    func signIn(email: String!, password: String!, success: (AnyObject) -> Void, error: (ServerError) -> Void) {
        ApiRequest.sharedInstance.post("/sessions", parameters: ["session": ["email": email, "password": password,
                                                                "authorization": self.deviseInormation(defaultProvider)]])
            .responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) in
                switch(response.result) {
                    case .Success(let data):
                        self.successSign(data)
                    case .Failure(let errorData):
                        self.failureSign(errorData, responseData: response.data!, error: error)
                }
        })
    }
    
    func signUp(email: String, password: String!, passwordConfirmation: String!, error: (ServerError) -> Void) {
        ApiRequest.sharedInstance.post("/registrations", parameters: ["user": ["email": email, "password": password, "password_confirmation": passwordConfirmation, "authorization": self.deviseInormation(defaultProvider)]])
            .responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) in
                switch(response.result) {
                case .Success(let data):
                    self.successSign(data)
                case .Failure(let errorData):
                    self.failureSign(errorData, responseData: response.data!, error: error)
                }
            })
    }
    
    func signInViaVK(email: String, error: (ServerError) -> Void) {
        ApiRequest.sharedInstance.post("/oauth/vkontakte", parameters: ["email": email, "auth": self.deviseInormation(vkProvider)])
            .responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) in
                switch(response.result) {
                case .Success(let data):
                    self.successSign(data)                    
                case .Failure(let errorData):
                    self.failureSign(errorData, responseData: response.data!, error: error)
                }
            })
    }
    
    func getCurrentUser() {
        let token = keychain.get("estudyauthtoken")
        if (token == nil) { return }
        
        ApiRequest.sharedInstance.get("/sessions/current", parameters: [:]).responseObject("current_user", completionHandler: {(response: Response<User, NSError>) in
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
    
    func deviseInormation(provider: String!) -> NSDictionary {
        let devise = UIDevice.currentDevice()
        let deviseData = ["platform": devise.systemName, "platform_version": devise.systemVersion,
                          "app_name": devise.name, provider: provider]
        return deviseData
    }
    
    func successSign(data: AnyObject) {
        if let token = data["token"] as? String {
            self.keychain.set(token, forKey: "estudyauthtoken")
            self.getCurrentUser()
        }
    }
    
    func failureSign(errorData: NSError!, responseData: NSData!, error: (ServerError) -> Void) {
        let errorValue = ServerError(parameters: errorData, data: responseData)
        error(errorValue)
    }
}