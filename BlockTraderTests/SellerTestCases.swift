//
//  SellerTestCases.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/8/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import XCTest
@testable import BlockTrader

class SellerTestCases: XCTestCase {
    var testVC: MainSellerViewController = MainSellerViewController()
    override func setUp() {
        super.setUp()
        self.testVC = MainSellerViewController()
        // Fix after the ninth
        self.testVC.appDelegate.credentials["api_authtoken"] = "WwrhqXqAeSDComFAZQBJw"
        self.testVC.appDelegate.credentials["id"] = 4
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHandleAcct() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        self.testVC.acctNumber = "woo"
        self.testVC.handleAcctNumber(acctNum: "acct_19OZRXFVm2X1aP9D")
        XCTAssertEqual(self.testVC.acctNumber, "acct_19OZRXFVm2X1aP9D")
        self.testVC.handleAcctNumber(acctNum: "")
        XCTAssertNotEqual(self.testVC.acctNumber, "")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
