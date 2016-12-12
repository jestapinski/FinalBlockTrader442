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
import Alamofire
import SwiftyJSON
import CoreLocation
import MapKit

class OrderFormViewControllerTests: XCTestCase {
    var testVC: OrderFormViewController = OrderFormViewController()
    override func setUp() {
        super.setUp()
        self.testVC = OrderFormViewController()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        // Can only test some initialization stuff
        XCTAssertEqual(self.testVC.customer, "")
        XCTAssertEqual(self.testVC.items, [])
        XCTAssertEqual(self.testVC.credentials.count, 0)
        XCTAssertEqual(self.testVC.orderNumber, 0)
        XCTAssertEqual(self.testVC.row, 0)
        XCTAssertEqual(self.testVC.price, 0.0)
        XCTAssertEqual(self.testVC.lat, 0.0)
        XCTAssertEqual(self.testVC.long, 0.0)

    }
    
    func testCheckValidFields(){
        self.testVC.desired_price = UITextField()
        self.testVC.desired_price.text! = "1.00"
        XCTAssertEqual(self.testVC.checkValidFields(), true)
        self.testVC.desired_price.text! = "10000.00"
        XCTAssertEqual(self.testVC.checkValidFields(), true)
        self.testVC.desired_price.text! = "0.51"
        XCTAssertEqual(self.testVC.checkValidFields(), true)
        self.testVC.desired_price.text! = "0.01"
        XCTAssertEqual(self.testVC.checkValidFields(), false)
        self.testVC.desired_price.text! = "-90.01"
        XCTAssertEqual(self.testVC.checkValidFields(), false)

    }
    

    
}
