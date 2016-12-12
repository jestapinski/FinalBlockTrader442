//
//  SellerGoingViewControllerTests.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/11/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import XCTest
import MapKit
@testable import BlockTrader

class SellerGoingViewControllerTests: XCTestCase {
    var testVC: SellerGoingViewController = SellerGoingViewController()
    override func setUp() {
        super.setUp()
        self.testVC = SellerGoingViewController()
        // Fix after the ninth
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertEqual(self.testVC.resturaunt, "")
        XCTAssertEqual(self.testVC.custName, "")
        XCTAssertEqual(self.testVC.orderFoods.count, 0)
        XCTAssertEqual(self.testVC.custFBId, "")
        XCTAssertEqual(self.testVC.custID, "")
        XCTAssertEqual(self.testVC.orderID, "")
        XCTAssertEqual(self.testVC.phoneNum, "")
        XCTAssertEqual(self.testVC.price, "")
    }
    
    func testGetFoods(){
        self.testVC.orderFoods.append(["name":"pizza"])
        self.testVC.orderFoods.append(["name":"kale"])
        XCTAssertEqual(self.testVC.getFoods(), "pizza\nkale")
    }
    
    func testUserPin(){
        self.testVC.mapView = MKMapView()
        XCTAssertEqual(self.testVC.mapView.annotations.count, 0)
        self.testVC.makeUserPin()
        XCTAssertEqual(self.testVC.mapView.annotations.count, 1)
    }
    
    func testRestPin(){
        self.testVC.mapView = MKMapView()
        XCTAssertEqual(self.testVC.mapView.annotations.count, 0)
        self.testVC.makeRestPin()
        XCTAssertNotNil(self.testVC.mapView.annotations)
    }
    
    func testUserLocationActionsHandler(){
        self.testVC.mapView = MKMapView()
        self.testVC.userLocationActions()
        XCTAssert(self.testVC.mapView.showsUserLocation)
        //XCTAssertNotNil(self.testVC.mapView.delegate)
    }
    
    func testSetPhone(){
        self.testVC.phoneLabel = UILabel()
        if self.testVC.phoneLabel != nil {
            self.testVC.setPhone(phone: "1-800-HOTLINE-BLING")
            XCTAssertEqual(self.testVC.phoneLabel.text, "1-800-HOTLINE-BLING")
            XCTAssertEqual(self.testVC.phoneNum, "1-800-HOTLINE-BLING")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
