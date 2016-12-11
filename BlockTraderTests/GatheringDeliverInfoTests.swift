//
//  GatheringDeliverInfoTests.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/8/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import BlockTrader

class GatheringDelivererViewControllerTests: XCTestCase {
    var testVC: GatheringDelivererViewController = GatheringDelivererViewController()
    override func setUp() {
        super.setUp()
        self.testVC = GatheringDelivererViewController()
        // Fix after the ninth
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        // Can only test some initialization stuff
        XCTAssertEqual(self.testVC.credentials.count, 0)
        XCTAssertNotNil(self.testVC.backendClient)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
