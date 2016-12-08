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
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var review: UIButton!
    @IBOutlet weak var desired_price: UITextField!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        desired_price.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    // MARK: request
    //creates a create order request
    func request(credentials: [String: Any], items: [Int], lat: Float, long: Float, completion: @escaping(_ num: Int) -> ())
    {
        //headers contain the authorization token to use with the API
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        //parameters contain user inputted info
        let parameters: Parameters = [
            "order": [
                "food_order_id": "",
                "customer_id": self.credentials["id"]!,
                "provider_id": 0,
                "address": "",
                "latitude": self.lat,
                "longitude": self.long,
                "delivery_status": "",
                "payment_id_user": "",
                "payment_id_reciever": "",
                "price": desired_price.text!,
                "real_price": suggestedPrice.text!
            ],
            "commit":"Create Order"
        ]
        //submits alamofire request to create the order
        Alamofire.request("http://germy.tk:3000/orders.json", method: .post, parameters: parameters, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = JSON(json)
                for item in self.items{
                    self.orderNumber = jsonarr["id"].intValue
                    //adds the foods to the food_order table
                    var food_order_parm: Parameters = [
                        "food_order":[
                            "food_id":"\(item)",
                            "order_id":"\(jsonarr["id"])"
                        ],
                        "commit": "Create Food order"
                    ]
                    //submits request to post to API
                    Alamofire.request("http://germy.tk:3000/food_orders", method: .post, parameters: food_order_parm, headers: headers)
                }
            }
            completion(self.orderNumber)
        }
        
    }
    
    // MARK: Submitting Forms
    // submits the form to move to the confirmation page
    @IBAction func submitForm(sender: AnyObject){
        request(credentials: self.credentials, items: self.items, lat: self.lat, long: self.long){(ku) -> () in
            self.orderNumber = ku
            if self.checkValidFields(){
                //Move to next page
                self.moveToConfirmation(orderNumber: ku)
            } else {
                let alert = UIAlertController(title: "Price", message: "Please enter a price over $0.50", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

        }
    }
    
    /**
     Checks that the form fields are valid for entering an order
    */
    // MARK: checkValidFields
    func checkValidFields() -> Bool{
        if(Float(self.desired_price.text!)! > 0.50){
            return true
            }
        return false
    }
    
    // MARK: - Navigation
    
    func moveToConfirmation(orderNumber: OrderNumber){
        performSegue(withIdentifier: "confirmation", sender: orderNumber)
    }
    //segues confirmtion -> to confirmation screen, backToFood -> returns back to food selection
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "confirmation") {
            let finalDestination = segue.destination as? OrderConfirmationViewController
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
        self.desired_price.keyboardType = UIKeyboardType.decimalPad
        self.desired_price.becomeFirstResponder()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        self.submit.layer.cornerRadius = 60
        self.review.layer.cornerRadius = 60
        self.review.titleLabel?.textAlignment = NSTextAlignment.center
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

        if let currLocation = locationManager.location{
            self.lat = Float(currLocation.coordinate.latitude)
            self.long = Float(currLocation.coordinate.longitude)
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
        self.suggestedPrice.text = String(format: "%.2f", self.price)
        self.desired_price.text = String(format: "%.2f", self.price)
            

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
