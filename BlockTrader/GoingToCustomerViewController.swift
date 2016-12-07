//
//  GoingToCustomerViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/3/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import MapKit

class GoingToCustomerViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate {
    
    var restName: String = ""
    var custName: String = ""
    var orderFoods : [[String : Any]] = []
    var orderID = ""
    var ourTimer: Timer?
    var phoneNum: String = ""
    var price: String = ""
    
    var custLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 10, longitude: 10)
    var restLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 10, longitude: 10)
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var custNameLabel: UILabel!
    @IBOutlet weak var custLocationLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var profPic: UIImageView!
    
    let backendClient = BackendClient()
    let stripeAPIClient = MyAPIClient()
    
    var custFBId: String = ""
    
    /**
     Function called by timer to update latitude and longitude in the DB
    */
    func execute(){
        let currentLocation = locationManager.location
        let lat = String(describing: currentLocation!.coordinate.latitude)
        let long = String(describing: currentLocation!.coordinate.longitude)
        self.backendClient.updateLocation(orderID: self.orderID, latitude: lat, longitude: long)
    }
    
    @IBAction func showPopover(sender: AnyObject){
        //performSegue(withIdentifier: "infoPopover", sender: "")
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "infoPop") as! CustInfoPopoverViewController
        vc.modalPresentationStyle = .popover
        let popover = vc.popoverPresentationController!
        popover.delegate = self
        popover.permittedArrowDirections = [.right, .down]
        popover.sourceView = sender as? UIView
        popover.sourceRect = sender.bounds
        vc.resturaunt = self.restName
        vc.custName = self.custName
        vc.custFBID = self.custFBId
        vc.orderFoods = self.getFoods()
        vc.price = self.price
        vc.profPic = self.backendClient.getProfilePicture(id: custFBId)
        vc.phone = self.phoneNum
        present(vc, animated: true, completion:nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: - Delivery functions
    /**
     Gets the customer and deliverer IDs from the order
    */
    @IBAction func customerHasFood(sender: AnyObject){
        //self.backendClient.getIDsFromOrder(orderID: self.orderID, completion: self.handleOurIDs)
        self.moveOn()
    }
    
    /**
     Gets the customerID and accountID from the DB.
     - parameter custID: The application ID of the customer
     - parameter acctID: The application ID of the deliverer
     - parameter price: The price of the order
    */
    func handleOurIDs (custID: String, acctID: String, price: String) {
        self.backendClient.getCustAndAcct(custID: custID, acctID: acctID, price: price, completion: self.completeCharge)
    }
    
    /**
     Completes the charge using Stripe backend
     - parameter actualCustID: The Stripe customer id of the customer
     - parameter actualAcctID: The Stripe account id of the deliverer
     - parameter cost: The price of the order
    */
    func completeCharge(actualCustID: String, actualAcctID: String, cost: String){
        self.stripeAPIClient.performCharge(providerID: actualAcctID, customerID: actualCustID, cost: cost, completion: self.moveOn)
    }
    
    @IBAction func cancelOrder(sender: AnyObject){
        self.backendClient.cancelOrder(orderID: self.orderID)
        //Go back to table view
        performSegue(withIdentifier: "cancelAfterFood", sender: "")
    }
    
    /**
     Callback function for completing the charge, updates the order to "Delivered" and proceeds to the next view controller
    */
    func moveOn(){
        //self.backendClient.updateStatus(orderID: self.orderID, message: "Delivered")
        performSegue(withIdentifier: "deliveredFood", sender: "")
    }
    
    // MARK: - MapView Functions
    /**
     Creates user location icon on mapView
     */
    func userLocationHandler(){
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
    
    /**
     Creates pin based on user location
     */
    func dropCustomerPin(){
        let custPin = MKPointAnnotation()
        custPin.coordinate = self.custLocation
        custPin.title = self.custName
        custPin.subtitle = "Location Description"
        mapView.addAnnotation(custPin)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.phoneLabel.text = self.phoneNum
        self.ourTimer = Timer.scheduledTimer(timeInterval: 5, target: self,selector: #selector(GoingToCustomerViewController.execute), userInfo: nil, repeats: true)
        self.userLocationHandler()
        self.dropCustomerPin()
        mapView.userTrackingMode = .follow

        // Do any additional setup after loading the view.
//        self.foodLabel.text = self.getFoods()
//        self.custNameLabel.text = self.custName
//        self.custLocationLabel.text = "Customer Location"
//        self.profPic.image = self.backendClient.getProfilePicture(id: self.custFBId)

    }

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "deliveredFood"){
            let secondViewController = segue.destination as? ProcessingPaymentViewController
            self.ourTimer?.invalidate()
            self.ourTimer = nil
            secondViewController?.price = self.price
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
