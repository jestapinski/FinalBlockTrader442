//
//  MyAPIClientTests.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/11/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import XCTest
import Foundation
@testable import BlockTrader

class MyAPIClientTests: XCTestCase {
    //Initializer
    //Get cents
    var testVC: MyAPIClient = MyAPIClient()
    override func setUp() {
        super.setUp()
        self.testVC = MyAPIClient()
        // Fix after the ninth
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(self.testVC.stripeBackendURL, "http://stripetest67442.herokuapp.com")
        XCTAssertNil(self.testVC.baseURLString)
        XCTAssertNil(self.testVC.defaultSource)
        XCTAssertEqual(self.testVC.sources.count, 0)
        XCTAssertEqual(self.testVC.customerID, "")
    }
    
    func testGetCents(){
        XCTAssertEqual(self.testVC.getCents(cost: ""), "")
        XCTAssertEqual(self.testVC.getCents(cost: "1."), "100")
        XCTAssertEqual(self.testVC.getCents(cost: "2.9"), "290")
        XCTAssertEqual(self.testVC.getCents(cost: "3.99"), "399")
    }
 
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    //API documentation
}
