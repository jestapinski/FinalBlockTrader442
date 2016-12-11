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
import MapKit

class OrderInfoViewControllerTests: XCTestCase {
    var testVC: OrderInfoViewController = OrderInfoViewController()
    override func setUp() {
        super.setUp()
        self.testVC = OrderInfoViewController()
        // Fix after the ninth
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        // Can only test some initialization stuff
        XCTAssertEqual(self.testVC.orderFoods.count, 0)
        XCTAssertNotNil(self.testVC.backendClient)
        XCTAssertEqual(self.testVC.orderID, "0")
        XCTAssertEqual(self.testVC.custID, "0")
        XCTAssertEqual(self.testVC.custName, "")
        XCTAssertEqual(self.testVC.orderDict.count, 0)
        XCTAssertNotNil(self.testVC.customerLocation)
        XCTAssertNotNil(self.testVC.restLocation)
    }
    
    func testSetPriceLabel(){
        let priceLbl = UILabel()
        self.testVC.priceLabel = priceLbl
        self.testVC.setPriceLabel(price: "23.9")
        XCTAssertEqual(self.testVC.price, "$23.90")
        XCTAssertEqual(self.testVC.priceLabel.text, "$23.90")
    }
    
    func testUserLocationHandler(){
        self.testVC.mapView = MKMapView()
        self.testVC.userLocationHandler()
        XCTAssert(self.testVC.mapView.showsUserLocation)
        XCTAssertNotNil(self.testVC.mapView.delegate)
    }
    
    func testCreateUserPin(){
        self.testVC.custName = "Prof H"
        self.testVC.createCustomerPin()
        self.testVC.mapView = MKMapView()
        XCTAssertNotNil(self.testVC.mapView.annotations)
    }
    
    func testCreateRestPin(){
        // :)
        self.testVC.restName = "A&M Creamery"
        self.testVC.createRestPin()
        self.testVC.mapView = MKMapView()
        XCTAssertNotNil(self.testVC.mapView.annotations)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
