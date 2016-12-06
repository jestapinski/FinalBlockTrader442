//
//  SellerGoingViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/2/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import MapKit

class SellerGoingViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var resturaunt: String = ""
    var custName: String = ""
    var orderFoods : [[String : Any]] = []
    var custFBId: String = ""
    var orderID: String = ""
    var ourTimer: Timer?
    
    let backendClient = BackendClient()
    
    var customerLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 10, longitude: 10)
    var restLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 10, longitude: 10)

    
    @IBOutlet weak var custNameLocationLabel: UILabel!
    @IBOutlet weak var restNameLabel: UILabel!
    @IBOutlet weak var foodsLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var profPic: UIImageView!

    let locationManager = CLLocationManager()
    
    /**
     Gets the names of all the food items ordered
    */
    func getFoods()-> String{
        var finalArray = [String]()
        for foodItem in self.orderFoods{
            finalArray.append(foodItem["name"] as! String)
        }
        return finalArray.joined(separator: "\n")
    }
    
    /**
     Timer function called to update user's location every five seconds in the DB
    */
    func execute(){
        let currentLocation = locationManager.location
        let lat = String(describing: currentLocation!.coordinate.latitude)
        let long = String(describing: currentLocation!.coordinate.longitude)
        self.backendClient.updateLocation(orderID: self.orderID, latitude: lat, longitude: long)
    }
    
    // MARK: - MapView Actions
    
    /**
     Creates pin based on user location
    */
    func makeUserPin(){
        let userPin = MKPointAnnotation()
        userPin.coordinate = self.customerLocation
        userPin.title = self.custName
        userPin.subtitle = "Location Description"
        mapView.addAnnotation(userPin)
    }
    
    /**
     Creates pin based on restaurant location
    */
    func makeRestPin(){
        let restPin = MKPointAnnotation()
        restPin.coordinate = self.restLocation
        restPin.title = self.resturaunt
        restPin.subtitle = "A tasty venue"
        mapView.userTrackingMode = .follow
        mapView.addAnnotation(restPin)
    }
    
    /**
     Creates user location icon on mapView
    */
    func userLocationActions(){
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ourTimer = Timer.scheduledTimer(timeInterval: 5, target: self,selector: #selector(SellerGoingViewController.execute), userInfo: nil, repeats: true)
        self.restNameLabel.text = resturaunt
        self.custNameLocationLabel.text = custName
        self.foodsLabel.text = self.getFoods()
        self.userLocationActions()
        self.makeUserPin()
        self.makeRestPin()
        self.profPic.image = self.backendClient.getProfilePicture(id: self.custFBId)

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    /**
     Moves on to next phase of delivery since food has been picked up. Updates status in DB.
    */
    @IBAction func foodHasBeenPickedUp(sender: AnyObject){
        self.backendClient.updateStatus(orderID: self.orderID, message: "Got Food")
        performSegue(withIdentifier: "goToCustomer", sender: "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "goToCustomer"){
            self.ourTimer?.invalidate()
            self.ourTimer = nil
            let secondViewController = segue.destination as? GoingToCustomerViewController
            secondViewController?.restName = self.resturaunt
            secondViewController?.custName = self.custName
            secondViewController?.orderFoods = self.orderFoods
            secondViewController?.restLocation = self.restLocation
            secondViewController?.custLocation = self.customerLocation
            secondViewController?.custFBId = self.custFBId
            secondViewController?.orderID = self.orderID
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
