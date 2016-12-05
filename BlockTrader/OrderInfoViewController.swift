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

class OrderInfoViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var orderFoods : [[String : Any]] = []
    let backendClient = BackendClient()
    var orderID: String = "0"
    var custID: String = "0"
    
    var custName: String = ""
    var restName: String = ""
    var custFBID: String = ""
    
    var orderDict : [String : Any] = [:]
    var customerLocation = CLLocationCoordinate2D(latitude: 10, longitude: 10)
    var restLocation = CLLocationCoordinate2D(latitude: 10, longitude: 10)
    
    let locationManager = CLLocationManager()
    
    //Define Outlets
    @IBOutlet weak var custNameLocationLabel: UILabel!
    @IBOutlet weak var restNameLabel: UILabel!
    @IBOutlet weak var foodsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var profPic: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(orderDict)
        self.mapView.delegate = self
        let latitude1 = self.orderDict["latitude"] as! String
        let longitude1 = self.orderDict["longitude"] as! String
        let lat : Float = Float(latitude1)!
        let long : Float = Float(longitude1)!
        self.customerLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        //let LitzmanLocation = CLLocationCoordinate2DMake(32.100668,34.775192)
        // Drop a pin, this works
        //        self.centerMapOnLocation(location: self.customerLocation)
        self.backendClient.getCustomerNameFromOrder(orderID: self.orderID, completion: self.assignCustomer)
        // Do any additional setup after loading the view.
    }
    
    private func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    /*func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        if (annotation.isKindOfClass(CustomAnnotation)) {
            let customAnnotation = annotation as? CustomAnnotation
            mapView.translatesAutoresizingMaskIntoConstraints = false
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("CustomAnnotation") as MKAnnotationView!
            
            if (annotationView == nil) {
                annotationView = customAnnotation?.annotationView()
            } else {
                annotationView.annotation = annotation;
            }
            
            self.addBounceAnimationToView(annotationView)
            return annotationView
        } else {
            return nil
        }
    }*/
    
    let regionRadius: CLLocationDistance = 20
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func assignCustomer(_ id: String, _ userID: String){
        self.custNameLocationLabel.text = id
        self.custName = id
        self.custID = userID
        let restID = self.orderFoods.first?["resturant_id"] as! String
        self.backendClient.getResturauntIDFromOrder(orderID: restID, completion: self.setRestLabel)
//        self.restNameLabel.text =
//        self.foodsLabel.text = self.getFoods()
        //self.backendClient.getPriceFromOrder(orderID: self.orderID, completion: self.assignPrice)
    }
    
    func setRestLabel(_ name: String, _ latitude: String, _ longitude: String){
        self.restNameLabel.text = name
        self.restName = name
        self.restLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(Float(latitude)!), longitude: CLLocationDegrees(Float(longitude)!))
        self.foodsLabel.text = self.getFoods()
        let Litzman = MKPointAnnotation()
        Litzman.coordinate = self.customerLocation
        Litzman.title = self.custName
        Litzman.subtitle = "Location Description"
        mapView.addAnnotation(Litzman)
        
        let restPin = MKPointAnnotation()
        restPin.coordinate = self.restLocation
        restPin.title = self.restName
        restPin.subtitle = "A tasty venue"
        self.centerMapOnLocation(location: self.restLocation)
        //restPin.color = MKPinAnnotationColor.Green
        mapView.addAnnotation(restPin)
        self.backendClient.getFacebookIDFromUserID(userID: self.custID, completion: self.setProfPic)
    }
    
    func setProfPic(fb_id: String){
        print(fb_id)
        self.custFBID = fb_id
        self.profPic.image = self.backendClient.getProfilePicture(id: fb_id)
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        // simple and inefficient example
//        
//        let annotationView = MKPinAnnotationView()
//        annotationView.title = annotation.title
//        annotationView.subtitle = annotation.subtitle
//        if annotation.subtitle! == "A tasty venue"{
//            annotationView.pinTintColor = UIColor.purple
//        } else {
//            annotationView.pinTintColor = UIColor.red
//        }
//        return annotationView
//    }
//    
    func assignPrice(_ price: String){
        self.priceLabel.text = price
    }
    
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
    
    @IBAction func moveToConfirm(sender: AnyObject){
        //POST request HERE
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.backendClient.postProviderID(userID: appDelegate.credentials["id"] as! String, orderID: orderID)
        performSegue(withIdentifier: "sellerconfirmed", sender: "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "sellerconfirmed"){
            //POST REQUEST SOMEWHERE, make this an IBAction from the button later
            let secondViewController = segue.destination as? SellerGoingViewController
            secondViewController?.resturaunt = self.restName
            secondViewController?.custName = self.custName
            secondViewController?.custFBId = self.custFBID
            secondViewController?.orderFoods = self.orderFoods
            secondViewController?.restLocation = self.restLocation
            secondViewController?.customerLocation = self.customerLocation
            print(secondViewController?.resturaunt)
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
