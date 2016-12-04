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
    
    let backendClient = BackendClient()
    
    var customerLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 10, longitude: 10)
    var restLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 10, longitude: 10)

    
    @IBOutlet weak var custNameLocationLabel: UILabel!
    @IBOutlet weak var restNameLabel: UILabel!
    @IBOutlet weak var foodsLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var profPic: UIImageView!

    let locationManager = CLLocationManager()
    
    func getFoods()-> String{
        var finalArray = [String]()
        for foodItem in self.orderFoods{
            finalArray.append(foodItem["name"] as! String)
        }
        return finalArray.joined(separator: "\n")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(resturaunt)
        self.restNameLabel.text = resturaunt
        self.custNameLocationLabel.text = custName
        self.foodsLabel.text = self.getFoods()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        let Litzman = MKPointAnnotation()
        Litzman.coordinate = self.customerLocation
        Litzman.title = self.custName
        Litzman.subtitle = "Location Description"
        mapView.addAnnotation(Litzman)
        
        let restPin = MKPointAnnotation()
        restPin.coordinate = self.restLocation
        restPin.title = self.resturaunt
        restPin.subtitle = "A tasty venue"
        mapView.userTrackingMode = .follow
//        self.centerMapOnLocation(location: self.restLocation)
        //restPin.color = MKPinAnnotationColor.Green
        mapView.addAnnotation(restPin)
        self.profPic.image = self.backendClient.getProfilePicture(id: self.custFBId)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func foodHasBeenPickedUp(sender: AnyObject){
        performSegue(withIdentifier: "goToCustomer", sender: "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "goToCustomer"){
            //POST REQUEST SOMEWHERE, make this an IBAction from the button later
            let secondViewController = segue.destination as? GoingToCustomerViewController
            secondViewController?.restName = self.resturaunt
            secondViewController?.custName = self.custName
            secondViewController?.orderFoods = self.orderFoods
            secondViewController?.restLocation = self.restLocation
            secondViewController?.custLocation = self.customerLocation
            secondViewController?.custFBId = self.custFBId
//            print(secondViewController?.resturaunt)
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
