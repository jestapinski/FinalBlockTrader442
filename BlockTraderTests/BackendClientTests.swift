//
//  BackendClientTests.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/11/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import XCTest
import SwiftyJSON
@testable import BlockTrader

class BackendClientTests: XCTestCase {
    var testVC: BackendClient = BackendClient()
    override func setUp() {
        super.setUp()
        self.testVC = BackendClient()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertEqual(self.testVC.credentials.count, 0)
    }
    
    func testProfilePicture(){
        XCTAssertNotNil(self.testVC.getProfilePicture(id: "696776167167123"))
    }
    
    func testJSONToDictionary(){
        let json : JSON =   [ "id" : 251,
            "payment_id_receiever" : "0",
            "real_price" : "6.25",
            "longitude" : "-79.94804",
            "provider_id" : 4,
            "latitude" : "40.43854",
            "payment_id_user" : "",
            "created_at" : "2016-12-09T18:58:55.387Z",
            "food_order_id" : "0",
            "address" : "",
            "price" : "10.3",
            "updated_at" : "2016-12-09T18:59:23.413Z",
            "url" : "something",
            "customer_id" : 12,
            "delivery_status" : "Delivered",
            "minutes" : 4687
        ]
        let niceDict = self.testVC.JSONtoDictionary(JSONelement: json)
        XCTAssertEqual(niceDict["id"] as! String, "251")
        XCTAssertEqual(niceDict["real_price"] as! String, "6.25")
        XCTAssertEqual(niceDict["delivery_status"] as! String, "Delivered")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
