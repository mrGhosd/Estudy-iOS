//
//  RegViewTests.swift
//  Estudy
//
//  Created by vsokoltsov on 30.06.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//

import XCTest

class RegViewTests: XCTestCase {
    var regView: RegView!
    
    class MockRegView {
        var signUpCalled = false
        
        func signUp() {
            signUpCalled = true
        }
    }

    override func setUp() {
        super.setUp()
        regView = RegView.init1("RegView")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmailFieldIsPresent() {
        XCTAssertNotNil(regView.emailField)
    }
    
    func testEmailErrorsFieldIsPresent() {
        XCTAssertNotNil(regView.emailError)
    }
    
    func testPasswordFieldIsPresent() {
        XCTAssertNotNil(regView.passwordField)
    }
    
    func testPasswordErrorsFieldIsPresent() {
        XCTAssertNotNil(regView.passwordError)
    }
    
    func testPasswordConfirmationFieldIsPresent() {
        XCTAssertNotNil(regView.passwordConfirmationField)
    }
    
    func testPasswordConfirmationErrorsFieldIsPresent() {
        XCTAssertNotNil(regView.passwordConfirmationError)
    }
    
    func testSignUpWasCalled() {
        var mock = MockRegView()
        
        mock.signUp()
        
        XCTAssert(mock.signUpCalled)
    }

}
