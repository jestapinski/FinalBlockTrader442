//
//  OrderLocationViewController.swift
//  BlockTrader
//
//  Created by Jeremy Lee on 12/6/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import FacebookLogin
import FacebookCore
import AlamofireImage
import MapKit

class OrderLocationViewController: UIViewController,MKMapViewDelegate {
    
    var custID: String = ""
    var orderNumber: Int = 0
    var credentials: [String : Any] = [:]
    var fb_url: String = ""
    var refreshControl: UIRefreshControl!
    var address: String = ""
    
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    

        
    @IBOutlet weak var mapView: MKMapView!

    /**
     Function called by timer to update latitude and longitude in the DB
     */
    func execute(timer:Timer){

        var orderNumber1 = timer.userInfo as! Int
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/orders/\(self.orderNumber).json"
        Alamofire.request(url, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = JSON(json)
                self.address = jsonarr["address"].stringValue
            }
            if(self.address != ""){
                let lat: String = self.address.components(separatedBy: ",")[0]
                let long: String = self.address.components(separatedBy: ",")[1]
                let latd: CLLocationDegrees = (lat as NSString).doubleValue as! CLLocationDegrees
                let longd: CLLocationDegrees = (long as NSString).doubleValue as! CLLocationDegrees
                if(latd != 0.0 && longd != 0.0){
                    let center = CLLocationCoordinate2D(latitude: latd, longitude: longd)
                    let location = CLLocation(latitude: latd, longitude: longd)
                    let regionRadius: CLLocationDistance = 1000
                    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                              regionRadius * 2.0, regionRadius * 2.0)
                    self.mapView.setRegion(coordinateRegion, animated: true)
                    var pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latd, longd)
                    var objectAnnotation = MKPointAnnotation()
                    objectAnnotation.coordinate = center
                    objectAnnotation.title = "Deliverer Location"
                    self.mapView.addAnnotation(objectAnnotation)
                }else{
                    print("can't parse address")
                }
            }
         }
    
        }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            if(self.orderNumber != 0){
                Timer.scheduledTimer(timeInterval: 5, target: self,selector: #selector(OrderLocationViewController.execute), userInfo: self.orderNumber, repeats: true)

            }
        }
    
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "backToOrderStatus"){
                let finalDestination = segue.destination as? OrderConfirmationViewController
                finalDestination?.credentials = self.credentials
                finalDestination?.orderNumber = self.orderNumber
            }
        }
    
    


    
    // MARK: - MapView Functions
    /**
     Creates user location icon on mapView
     */
//    func userLocationHandler(){
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
//        self.mapView.showsUserLocation = true
//    }
    

}
    


