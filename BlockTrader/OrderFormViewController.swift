//
//  OrderFormViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 11/26/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import MapKit

/**
 View controller upon which a user can submit an order
 */
class OrderFormViewController: UIViewController, CLLocationManagerDelegate {
    
    var customer: String = ""
    var credentials: [String : Any] = [:]
    var items = [Int]()
    var orderNumber: Int = 0
    var row: Int = 0
    var price: Float = 0.0
    var lat: Float = 0.0
    var long: Float = 0.0
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var cust_id: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var suggestedPrice: UILabel!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var review: UIButton!

    //Change below to have better UX
    @IBOutlet weak var desired_price: UITextField!
    
    func request(credentials: [String: Any], items: [Int], lat: Float, long: Float, completion: @escaping(_ num: Int) -> ())
    {
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let parameters: Parameters = [
            "order": [
                "food_order_id": "",
                "customer_id": self.credentials["id"]!,
                "provider_id": 0,
                "address": "",
                "latitude": latitude.text!,
                "longitude": longitude.text!,
                "delivery_status": "",
                "payment_id_user": "",
                "payment_id_reciever": "",
                "price": desired_price.text!
            ],
            "commit":"Create Order"
        ]
        
        Alamofire.request("http://germy.tk:3000/orders.json", method: .post, parameters: parameters, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = JSON(json)
                for item in self.items{
                    self.orderNumber = jsonarr["id"].intValue
                    var food_order_parm: Parameters = [
                        "food_order":[
                            "food_id":"\(item)",
                            "order_id":"\(jsonarr["id"])"
                        ],
                        "commit": "Create Food order"
                    ]
                    Alamofire.request("http://germy.tk:3000/food_orders", method: .post, parameters: food_order_parm, headers: headers)
                }
            }
            completion(self.orderNumber)
        }
        
    }
    
    // MARK: Submitting Forms
    @IBAction func submitForm(sender: AnyObject){
        request(credentials: self.credentials, items: self.items, lat: self.lat, long: self.long){(ku) -> () in
            self.orderNumber = ku
            if self.checkValidFields(){
                //Move to next page
                self.moveToConfirmation(orderNumber: ku)
            } else {
                print("Fields are not correct")
            }

        }
    }
    
    /**
     Checks that the form fields are valid for entering an order
     
     TODO check ""
    */
    func checkValidFields() -> Bool{
//        if let food = self.food_choice.text,
//           let location = self.customer_location.text,
//           let resturaunt = self.resturaunt_choice.text{
//            return food != "" && location != "" && resturaunt != "" && priceIsValid()
//        }
        return true
    }
    
    /**
     Checks that the desired price field is a valid amount
    */
    func priceIsValid() -> Bool{
        return (self.desired_price.text != "")
    }

    
    // MARK: - Navigation
    
    func moveToConfirmation(orderNumber: OrderNumber){
        performSegue(withIdentifier: "confirmation", sender: orderNumber)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "confirmation") {
            let finalDestination = segue.destination as? OrderConfirmationViewController
            print("confirmed")
            finalDestination?.credentials =	 self.credentials
            finalDestination?.orderNumber = self.orderNumber
        } else if (segue.identifier == "backToFood") {
            let finalDestination = segue.destination as? PickFoodViewController
            finalDestination?.credentials =	 self.credentials
            finalDestination?.items = self.items
            finalDestination?.row = self.row
            finalDestination?.customer = self.customer
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        self.submit.layer.cornerRadius = 60
        self.review.layer.cornerRadius = 60
        self.review.titleLabel?.textAlignment = NSTextAlignment.center
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

        if let currLocation = locationManager.location{
            self.lat = Float(currLocation.coordinate.latitude)
            self.long = Float(currLocation.coordinate.longitude)
            self.latitude.text = String(self.lat)
            self.longitude.text = String(self.long)
        }

        //Checking Stripe call, can remove when deployed
        self.cust_id.text = customer
        // Do any additional setup after loading the view.
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/restaurants.json?rest_id=\(self.row)"
        Alamofire.request(url, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = JSON(json)
                for item in jsonarr.array!{
                    self.restaurantName.text = item["name"].stringValue
                }
                
            }
        }

        let url2 = "http://germy.tk:3000/foods.json?rest_id=\(self.row)"
        Alamofire.request(url2, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = JSON(json)
                for item in jsonarr.array!{
                    if self.items.contains(Int(item["id"].stringValue)!){
                    self.price = self.price + Float(item["original_price"].stringValue)!
                }
                
            }
        }
        self.suggestedPrice.text = self.price.description
        self.desired_price.text = self.price.description
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
