//
//  OpenOrdersTableViewControllerTests.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/8/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import BlockTrader

class OrderLocationViewControllerTests: XCTestCase {
    var testVC: OrderLocationViewController = OrderLocationViewController()
    override func setUp() {
        super.setUp()
        self.testVC = OrderLocationViewController()


    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization(){
        //Test values start off as nil
        XCTAssertEqual(self.testVC.custID, "")
        XCTAssertEqual(self.testVC.orderNumber, 0)
        XCTAssertEqual(self.testVC.credentials.count, 0)
        XCTAssertEqual(self.testVC.fb_url, "")
        XCTAssertEqual(self.testVC.address, "")
        XCTAssertEqual(self.testVC.latitude, 0.0)
        XCTAssertEqual(self.testVC.longitude, 0.0)
    }

    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
