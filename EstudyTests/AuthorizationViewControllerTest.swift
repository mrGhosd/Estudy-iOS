//
//  AuthorizationViewController.swift
//  Estudy
//
//  Created by vsokoltsov on 27.06.16.
//  Copyright © 2016 vsokoltsov. All rights reserved.
//
import UIKit
import XCTest
@testable import Estudy

class AuthorizationViewControllerTest: XCTestCase {
    var viewController: AuthorizationViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testShowingAuthViewIfIsAuthSelected() {
        defineStoryboardWithParams(true)
        XCTAssert(viewController.segmentSwitcher.selectedSegmentIndex == 0, "Auth view is chosen")
    }
    
    func testShowingRegViewIfIsRegSelected() {
        defineStoryboardWithParams(false)
        XCTAssert(viewController.segmentSwitcher.selectedSegmentIndex == 1, "Reg view is chosen")
    }
    
    func testSegmentSwitcherExist() {
        defineStoryboardWithParams(true)
        XCTAssertNotNil(viewController.segmentSwitcher)
    }
    
    func testContentViewExist() {
        defineStoryboardWithParams(true)
        XCTAssertNotNil(viewController.contentView)
    }
    
    func testVkAuthButtonExist() {
        defineStoryboardWithParams(true)
        XCTAssertNotNil(viewController.vkAuthButton)
    }
    
    func defineStoryboardWithParams(isAuth: Bool!) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.classForCoder))
        viewController = storyboard.instantiateViewControllerWithIdentifier("AuthorizationViewController") as! AuthorizationViewController
        viewController.isAuth = isAuth
        viewController.loadView()
        UIApplication.sharedApplication().keyWindow!.rootViewController = viewController
        NSRunLoop.mainRunLoop().runUntilDate(NSDate())
    }
}
