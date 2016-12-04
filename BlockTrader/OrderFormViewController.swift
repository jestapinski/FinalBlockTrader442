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


/**
 View controller upon which a user can submit an order
 */
class OrderFormViewController: UIViewController {
    
    var customer: String = ""
    var credentials: [String : Any] = [:]
    var items = [Int]()
    var orderNumber: Int = 0
    var row: Int = 0
    var price: Float = 0.0
    
    @IBOutlet weak var cust_id: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var suggestedPrice: UILabel!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!

    //Change below to have better UX
    @IBOutlet weak var desired_price: UITextField!
    
    // MARK: Submitting Forms
    @IBAction func submitForm(sender: AnyObject){
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        
        let parameters: Parameters = [
            "order": [
                "food_order_id": "",
                "customer_id": self.credentials["id"]!,
                "provider_id": 0,
                "address": "123",
                "latitude": latitude.text!,
                "longitude": longitude.text!,
                "delivery_status": "",
                "payment_id_user": "",
                "payment_id_reciever": ""
            ],
            "commit":"Create Order"
        ]
        
        // All three of these calls are equivalent
        Alamofire.request("http://germy.tk:3000/orders.json", method: .post, parameters: parameters, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = JSON(json)
                for item in self.items{
                    var food_order_parm: Parameters = [
                    "food_order":[
                        "food_id":"\(item)",
                        "order_id":"\(jsonarr["id"])"
                    ],
                    "commit": "Create Food order"
                    ]
                    Alamofire.request("http://germy.tk:3000/food_orders", method: .post, parameters: food_order_parm, headers: headers)
                    print("\(jsonarr["id"]) item#: \(item)")
                }
            }
        }

        

        
        if self.checkValidFields(){
            //Submit order
            let orderNumber = self.submitOrder()
            //Move to next page
            self.moveToConfirmation(orderNumber: orderNumber)
        } else {
            print("Fields are not correct")
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
    
    //TODO
    func submitOrder() -> OrderNumber{
        //Some API call to post order to DB, be sure to use cust_id
        return 1
    }
    
    // MARK: - Navigation
    
    func moveToConfirmation(orderNumber: OrderNumber){
        performSegue(withIdentifier: "confirmation", sender: orderNumber)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "confirmation") {
            let finalDestination = segue.destination as? OrderConfirmationViewController
            //finalDestination?.orderNumber = sender as! OrderNumber
            finalDestination?.custID = self.customer
        } else if (segue.identifier == "backToFood") {
            let finalDestination = segue.destination as? PickFoodViewController
            finalDestination?.customer = self.customer
            finalDestination?.credentials = self.credentials

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
                    print("JSON1: \(item["name"].stringValue)")
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
                    print("JSONthing: \(item["original_price"].stringValue)")
                    self.price = self.price + Float(item["original_price"].stringValue)!
                }
                
            }
        }
        self.suggestedPrice.text = self.price.description
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
