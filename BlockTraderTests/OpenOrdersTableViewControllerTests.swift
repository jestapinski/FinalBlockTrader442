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

class OpenOrdersTableViewControllerTests: XCTestCase {
    var testVC: OpenOrdersTableViewController = OpenOrdersTableViewController()
    override func setUp() {
        super.setUp()
        self.testVC = OpenOrdersTableViewController()
        self.testVC.credentials["api_authtoken"] = "WwrhqXqAeSDComFAZQBJw"
        // Fix after the ninth
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization(){
        //Test values start off as nil
        XCTAssertEqual(self.testVC.TableData.count, 0)
        XCTAssertEqual(self.testVC.foodIDs.count, 0)
        XCTAssertEqual(self.testVC.TableData.count, 0)
    }
    
    func testAggregateFoodItems(){
        let v = UILabel()
        v.text = "Hello"
        XCTAssertEqual(v.text, "Hello")
        self.testVC.backendClient.credentials["api_authtoken"] = "WwrhqXqAeSDComFAZQBJw"
        let inp = ["3", "4"]
        self.testVC.foodIDs = [["3"],["4"]]
        self.testVC.TableData = inp
        self.testVC.aggregateFoodItems(inp, 0, [:])
        //Below happens async, we cannot really test?
        //XCTAssertEqual(self.testVC.TableRests, ["The Exchange", "The Underground"])
    }
    
    func testappendRName(){
        self.testVC.appendRName(name: "67442", "", "", lastOne: ["hello" : "world"], lOFID: ["1"], index: 0)
        XCTAssertEqual(self.testVC.TableRests, ["67442"])
        XCTAssertEqual(self.testVC.allJSONs.count, 1)
    }
    
    func testcombineBack(){
        self.testVC.backendClient.credentials["api_authtoken"] = "WwrhqXqAeSDComFAZQBJw"
        self.testVC.foodIDs = [["3"],["4"]]
        self.testVC.TableData = ["3", "4"]
        self.testVC.TableRests = ["The Exchange", "The Underground"]
        self.testVC.allJSONs = [["name" : "Sandwich"], ["name" : "Salad"]]
        self.testVC.combineBack()
        XCTAssertEqual(self.testVC.TableRests, ["The Exchange", "The Underground"])
        XCTAssertNotNil(self.testVC.allJSONs)
        XCTAssertEqual(self.testVC.foodIDs.first!.first!, "3")
    }
    
    func testsetPriceLabel(){
        XCTAssertEqual(self.testVC.setPriceLabel(price: "10.00"), "$10.00")
        XCTAssertEqual(self.testVC.setPriceLabel(price: "21.0"), "$21.00")
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
