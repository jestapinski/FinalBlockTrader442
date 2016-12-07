//
//  OrderInfoViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/2/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

//Put buttons to cener on different things
import UIKit
import SwiftyJSON
import MapKit

class OrderInfoViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate {
    
    var orderFoods : [[String : Any]] = []
    let backendClient = BackendClient()
    let API = MyAPIClient.sharedClient
    var orderID: String = "0"
    var custID: String = "0"
    var price: String = "0"
    
    var custName: String = ""
    var restName: String = ""
    var custFBID: String = ""
    
    var orderDict : [String : Any] = [:]
    var customerLocation = CLLocationCoordinate2D(latitude: 10, longitude: 10)
    var restLocation = CLLocationCoordinate2D(latitude: 10, longitude: 10)
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 400

    
    //Define Outlets
    @IBOutlet weak var custNameLocationLabel: UILabel!
    @IBOutlet weak var restNameLabel: UILabel!
    @IBOutlet weak var foodsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var profPic: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.backendClient.getPriceFromOrder(orderID: self.orderID, completion: self.setPriceLabel)
        let latitude1 = self.orderDict["latitude"] as! String
        let longitude1 = self.orderDict["longitude"] as! String
        let lat : Float = Float(latitude1)!
        let long : Float = Float(longitude1)!
        self.customerLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
        self.userLocationHandler()
        
        self.backendClient.getCustomerNameFromOrder(orderID: self.orderID, completion: self.assignCustomer)
        // Do any additional setup after loading the view.
    }

    
    /**
     Sets the price label to be the price according to the price returned from the API call for price
     - parameter price: The price passed back from the API call
    */
    func setPriceLabel(price: String){
        let newPrice = self.API.getCents(cost: price)
        let dollars = newPrice[0..<(newPrice.characters.count - 3)]
        let cents = newPrice[(newPrice.characters.count - 2)..<(newPrice.characters.count - 1)]
        let finalPrice = "$" + dollars + "." + cents
        self.price = finalPrice
        self.priceLabel.text = finalPrice
    }
    
    /**
     Location Manager function which updates and sets location according to the user location
    */
    private func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    // MARK: - MapView Functions
    
    /**
     Centers map on a certain location
     - parameter location: The coordinates of the point to be centered on
    */
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /**
     Creates point of user's location on the mapview
     */
    func userLocationHandler(){
        self.mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
    
    /**
     Assigns labels and variables based on the customer's name and ID
     - parameter id: The user's name
     - parameter userID: The user's id from the API
    */
    func assignCustomer(_ id: String, _ userID: String){
        self.custNameLocationLabel.text = id
        self.custName = id
        self.custID = userID
        let restID = self.orderFoods.first?["resturant_id"] as! String
        self.backendClient.getResturauntIDFromOrder(orderID: restID, completion: self.setRestLabel)
    }
    
    /**
     Create the customer pin based on location and drop on map
     */
    func createCustomerPin(){
        let custPt = MKPointAnnotation()
        custPt.coordinate = self.customerLocation
        custPt.title = self.custName
        custPt.subtitle = "Location Description"
        mapView.addAnnotation(custPt)
    }

    /**
     Create the restaurant pin based on location and drop on map
     */
    func createRestPin(){
        let restPin = MKPointAnnotation()
        restPin.coordinate = self.restLocation
        restPin.title = self.restName
        restPin.subtitle = "A tasty venue"
        mapView.addAnnotation(restPin)
    }
    
    // MARK: - UI Labels
    
    /**
     Sets labels based on restaurant name, also creates the pin annotations
     - parameter name: The restaurant name passed from the API
     - parameter latitude: The latitude passed from the API
     - parameter longitude: The longitude passed from the API
     */
    func setRestLabel(_ name: String, _ latitude: String, _ longitude: String){
        self.restNameLabel.text = name
        self.restName = name
        self.restLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(Float(latitude)!), longitude: CLLocationDegrees(Float(longitude)!))
        //self.foodsLabel.text = self.getFoods()
        self.createCustomerPin()
        self.createRestPin()
        self.centerMapOnLocation(location: self.restLocation)
        //restPin.color = MKPinAnnotationColor.Green
        self.backendClient.getFacebookIDFromUserID(userID: self.custID, completion: self.setProfPic)
    }
    
    /**
     Sets the customer's profile pipc image on the ViewController
     - parameter fb_id: The customer's Facebook id, passed from API
    */
    func setProfPic(fb_id: String){
        print(fb_id)
        self.custFBID = fb_id
        self.profPic.image = self.backendClient.getProfilePicture(id: fb_id)
    }
    
    /**
     Assigns the price label based on the price of the order, passed from the API
     - parameter price: The price of the order, passed from the API
    */
    func assignPrice(_ price: String){
        self.priceLabel.text = price
    }
    
    /**
     Gets all of the foods from the orderFoods array and joins them neatly together for viewing
    */
    func getFoods()-> String{
        var finalArray = [String]()
        for foodItem in self.orderFoods{
            finalArray.append(foodItem["name"] as! String)
        }
        return finalArray.joined(separator: "\n")
    }
    
    // MARK: - Navigation
    
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
        vc.custFBID = self.custFBID
        vc.orderFoods = self.getFoods()
        vc.price = self.price
        vc.phone = ""
        vc.profPic = self.backendClient.getProfilePicture(id: custFBID)
        present(vc, animated: true, completion:nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }

    /**
     Updates the order in the db with the deliverer's ID, also updates the delivery status
     */
    @IBAction func moveToConfirm(sender: AnyObject){
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //self.backendClient.postProviderID(userID: appDelegate.credentials["id"] as! String, orderID: orderID)
        //self.backendClient.updateStatus(orderID: self.orderID, message: "Going to Get Food")
        performSegue(withIdentifier: "sellerconfirmed", sender: "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "sellerconfirmed"){
            let secondViewController = segue.destination as? SellerGoingViewController
            secondViewController?.resturaunt = self.restName
            secondViewController?.custName = self.custName
            secondViewController?.custFBId = self.custFBID
            secondViewController?.orderFoods = self.orderFoods
            secondViewController?.restLocation = self.restLocation
            secondViewController?.customerLocation = self.customerLocation
            secondViewController?.orderID = self.orderID
            secondViewController?.custID = self.custID
            secondViewController?.price = self.price
        } else if (segue.identifier == "infoPopover"){
            let vc = segue.destination as! CustInfoPopoverViewController
            let controller = vc.popoverPresentationController
            
            if controller != nil
            {
                controller?.delegate = self
            }
        }
    }
    
    // MARK: - Memory Functions
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
