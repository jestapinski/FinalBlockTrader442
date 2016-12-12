//
//  CustInfoPopoverTests.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/11/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import XCTest
import MapKit
@testable import BlockTrader

class CustInfoPopoverTests: XCTestCase {
    var testVC: CustInfoPopoverViewController = CustInfoPopoverViewController()
    override func setUp() {
        super.setUp()
        self.testVC = CustInfoPopoverViewController()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        // Can only test some initialization stuff
        XCTAssertEqual(self.testVC.resturaunt, "")
        XCTAssertNotNil(self.testVC.custName, "")
        XCTAssertNotNil(self.testVC.custFBID, "")
        XCTAssertNotNil(self.testVC.orderFoods, "")
        XCTAssertNotNil(self.testVC.price, "")
        XCTAssertNotNil(self.testVC.phone, "")
        XCTAssertNil(self.testVC.profPic)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
