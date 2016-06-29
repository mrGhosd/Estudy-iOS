//
//  AuthViewTests.swift
//  Estudy
//
//  Created by vsokoltsov on 30.06.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import XCTest

class AuthViewTests: XCTestCase {
    var authView: AuthView!
    
    override func setUp() {
        super.setUp()
        authView = AuthView.init1("AuthView")
    }
    
    class MockAuthView {
        var signInCalled = false
        
        func signIn() {
            signInCalled = true
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEmailFieldIsPresent() {
        XCTAssertNotNil(authView.emailField)
    }

    func testEmailErrorsFieldIsPresent() {
        XCTAssertNotNil(authView.emailErrors)
    }
    
    func testPasswordFieldIsPresent() {
        XCTAssertNotNil(authView.passwordField)
    }
    
    func testPasswordErrorsFieldIsPresent() {
        XCTAssertNotNil(authView.passwordErrors)
    }
    
    func testSignInButtonIsPresent() {
        XCTAssertNotNil(authView.signInButton)
    }
    
    func testSignInButtonClicked() {
        var mock = MockAuthView()
        
        mock.signIn()
        
        XCTAssert(mock.signInCalled, "sign in method was called")
    }
}
