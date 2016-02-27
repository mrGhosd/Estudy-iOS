//
//  AuthDelegate.swift
//  Estudy
//
//  Created by vsokoltsov on 27.02.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import Foundation

@objc protocol Authorization {
    optional func signIn(email: String!, password: String!)
    optional func signUp(email: String!, pasword: String!, password_confirmation: String!)
}