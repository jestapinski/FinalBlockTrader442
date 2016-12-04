//
//  GoingToCustomerViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/3/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import MapKit

class GoingToCustomerViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var restName: String = ""
    var custName: String = ""
    var orderFoods : [[String : Any]] = []
    
    var custLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 10, longitude: 10)
    var restLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 10, longitude: 10)
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var custNameLabel: UILabel!
    @IBOutlet weak var custLocationLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var profPic: UIImageView!
    
    let backendClient = BackendClient()
    
    var custFBId: String = ""
    
    @IBAction func customerHasFood(sender: AnyObject){
        //Some API call
        performSegue(withIdentifier: "deliveredFood", sender: "")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        let Litzman = MKPointAnnotation()
        Litzman.coordinate = self.custLocation
        Litzman.title = self.custName
        Litzman.subtitle = "Location Description"
        mapView.addAnnotation(Litzman)
        
        mapView.userTrackingMode = .follow

        // Do any additional setup after loading the view.
        self.foodLabel.text = self.getFoods()
        self.custNameLabel.text = self.custName
        self.custLocationLabel.text = "Customer Location"
        self.profPic.image = self.backendClient.getProfilePicture(id: self.custFBId)

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "deliveredFood"){
        //POST REQUEST SOMEWHERE, make this an IBAction from the button later
        let secondViewController = segue.destination as? ProcessingPaymentViewController
        //            secondViewController?.resturaunt = self.restName
        //            secondViewController?.custName = self.custName
        //            secondViewController?.orderFoods = self.orderFoods
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
