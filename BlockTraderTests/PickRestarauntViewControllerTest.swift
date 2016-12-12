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

class PickRestarauntViewControllerTests: XCTestCase {
    var testVC: PickRestarauntViewController = PickRestarauntViewController()
    override func setUp() {
        super.setUp()
        self.testVC = PickRestarauntViewController()


    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization(){
        //Test values start off as nil
        XCTAssertEqual(self.testVC.customer, "")
        XCTAssertEqual(self.testVC.Rests.count, 0)
        XCTAssertEqual(self.testVC.tableTitle, [])
        XCTAssertEqual(self.testVC.credentials.count, 0)
    }

    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
