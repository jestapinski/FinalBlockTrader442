//
//  ProcessingPaymentViewControllerTests.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/11/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import XCTest
@testable import BlockTrader

class ProcessingPaymentViewControllerTests: XCTestCase {
    var testVC: ProcessingPaymentViewController = ProcessingPaymentViewController()
    override func setUp() {
        super.setUp()
        self.testVC = ProcessingPaymentViewController()
        // Fix after the ninth
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        // Can only test some initialization stuff
        XCTAssertEqual(self.testVC.price, "")
    }
    
    func testPriceLabel(){
        self.testVC.priceLbl = UILabel()
        if self.testVC.priceLbl != nil {
            self.testVC.viewDidLoad()
            self.testVC.priceLbl = UILabel()
            XCTAssertEqual(self.testVC.priceLbl.text, "You earned ")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
