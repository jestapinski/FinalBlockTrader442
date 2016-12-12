//
//  OrderInfoViewControllerTests.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/8/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import BlockTrader
import UIKit


class GatheringInfoViewControllerTests: XCTestCase {
    var testVC: GatheringInfoViewController = GatheringInfoViewController()
    override func setUp() {
        super.setUp()
        self.testVC = GatheringInfoViewController()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        // Can only test some initialization stuff
        XCTAssertEqual(self.testVC.credentials.count, 0)

    }
    

    
}
