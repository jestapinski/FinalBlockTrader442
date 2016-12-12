//
//  BackendClient.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/1/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import AlamofireImage

class BackendClient {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var credentials : [String : Any] = [:]
    
    init(){
        self.credentials = appDelegate.credentials
    }
    
    /**
    Takes a person's Facebook ID and returns their Facebook Profile Picture
     - parameter id: The Facebook ID
    */
    func getProfilePicture(id: String) -> UIImage{
        let imgURLString = "http://graph.facebook.com/" + "v2.8/" + id + "/picture?type=large" //type=normal
        let imgURL = NSURL(string: imgURLString)
        let imageData = NSData(contentsOf: imgURL! as URL)
        let image = UIImage(data: imageData! as Data)
        return image!
    }
    
    /**
     Takes a userID from the API and returns the person's Facebook ID
     - parameter userID: The API ID of the user
     - parameter completion: The continuation function to be run after the response.
    */
    func getFacebookIDFromUserID(userID: String, completion: @escaping (String) -> Void){
        self.credentials = appDelegate.credentials
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/users/\(Int(userID)!).json"
        print(url)
        Alamofire.request(url, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = JSON(json)
                completion(self.JSONtoDictionary(JSONelement: jsonarr)["fb_id"] as! String)
            }
        }
    }
    
    /**
     Takes a userID from the API and returns the person's Stripe Account SellerID
     - parameter userID: The API ID of the user
     - parameter completion: The continuation function to be run after the response.
     */
    func getAccountForUser(userID: String, completion: @escaping (Bool) -> Void){
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/users/\(Int(userID)!).json"
        print(url)
        Alamofire.request(url, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = JSON(json)
                let acct = self.JSONtoDictionary(JSONelement: jsonarr)["account_id"] as! String
                completion(acct != "")
            }
        }
    }
    
    /**
     Takes a userID and an orderID and posts the user as the deliverer for that order
     - parameter userID: The API id of the deliverer
     - parameter orderID: The API id of the order
    */
    func postProviderID(userID: String, orderID: String){
        let headers = [
            "Authorization": " Token token=\(appDelegate.credentials["api_authtoken"]!)"
        ]
        
        
        let parameters: Parameters = [
            "commit": "Update Order",
            "id": orderID,
            "order":[
                "provider_id": userID
            ]
        ]
        let edit_url = "http://germy.tk:3000/orders/" + orderID
        Alamofire.request(edit_url, method: .patch, parameters: parameters, headers: headers)

    }
    
    /**
     Takes an orderID from the API as well as a message and updates the delivery status to that message.
     - parameter orderID: The API ID of the order.
     - parameter message: The message to be posted
    */
    func updateStatus(orderID: String, message: String){
        let headers = [
            "Authorization": " Token token=\(appDelegate.credentials["api_authtoken"]!)"
        ]
        
        
        let parameters: Parameters = [
            "commit": "Update Order",
            "id": orderID,
            "order":[
                "delivery_status": message
            ]
        ]
        let edit_url = "http://germy.tk:3000/orders/" + orderID
        Alamofire.request(edit_url, method: .patch, parameters: parameters, headers: headers)

    }
    
    /**
     Takes an orderID from the API as well as a location and updates the deliverer's location to that location.
     - parameter orderID: The API ID of the order.
     - parameter latitude: The latitude of the deliverer
     - parameter longitude: The longitude of the deliverer
     */
    func updateLocation(orderID: String, latitude: String, longitude: String){
        let headers = [
            "Authorization": " Token token=\(appDelegate.credentials["api_authtoken"]!)"
        ]
        
        
        let parameters: Parameters = [
            "commit": "Update Order",
            "id": orderID,
            "order":[
                "address": latitude + "," + longitude
            ]
        ]
        let edit_url = "http://germy.tk:3000/orders/" + orderID
        Alamofire.request(edit_url, method: .patch, parameters: parameters, headers: headers)

    }
    
    /**
     Cancels an order from the API
     - parameter orderID: The API ID of the order.
     */
    func cancelOrder(orderID: String){
        let headers = [
            "Authorization": " Token token=\(appDelegate.credentials["api_authtoken"]!)"
        ]
        
        
        let parameters: Parameters = [
            "commit": "Update Order",
            "id": orderID,
            "order":[
                "provider_id": "0",
                "delivery_status": ""
            ]
        ]
        let edit_url = "http://germy.tk:3000/orders/" + orderID
        Alamofire.request(edit_url, method: .patch, parameters: parameters, headers: headers)
        
    }
    
    /**
     Takes a food ID and returns the model of that food item in a completion (To be executed in a loop)
     - parameter foodID: The API ID of the food.
     - parameter index: The current index of the array
     - parameter originalArray: The array being passed around
     - parameter completion: The function to be executed after getting the model
     */
    func mapToFoodJSONs(foodID: String, index: Int, originalArray: [String], completion: @escaping ([String], Int, [String : Any]) -> Void){
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
            let url = "http://germy.tk:3000/foods/\(Int(foodID)!).json"
            print(url)
            Alamofire.request(url, headers: headers).responseJSON { response in
                if let json = response.result.value{
                    let jsonarr = JSON(json)
                    completion(originalArray, index + 1, self.JSONtoDictionary(JSONelement: jsonarr))
                }
    }
    
    
    }
    
    /**
     Takes a JSON element and converts it to a swift dictionary
     - parameter JSONelement: The JSON model returned from the API
     */
    func JSONtoDictionary(JSONelement: JSON) -> [String : Any]{
        var finalDictionary : [String : Any] = [:]
        for (key, object) in JSONelement {
            finalDictionary[key] = object.stringValue
        }
        return finalDictionary
    }
    
    /**
     Gets all orders from the API and maps them to swift dictionaries
     - parameter completion: The function to be executed after getting all the orders
     */
    func getOrders(completion: @escaping ([[String : Any]]) -> Void){
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/orders.json"
        print(url)
        var finalArray = [[String : Any]]()
        Alamofire.request(url, headers: headers).responseJSON { response in
            DispatchQueue.main.async {
            if let json = response.result.value{
                let jsonarr = JSON(json)
                for item in jsonarr.array!{
                    finalArray.append(self.JSONtoDictionary(JSONelement: item))
                }
                
                
            }
            completion(finalArray)
        }
        }
    }

    /**
     Takes an orderID from the API and gets the API ID of the customer
     - parameter orderID: The API ID of the order.
     - parameter completion: The function to be executed after getting the customer
     */
    func getCustomerNameFromOrder(orderID: String, completion: @escaping (String, String) -> Void){
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/orders/\(Int(orderID)!).json"
        print(url)
        Alamofire.request(url, headers: headers).responseJSON { response in
            DispatchQueue.main.async {
            if let json = response.result.value{
                let jsonarr = self.JSONtoDictionary(JSONelement: JSON(json))["customer_id"] as! String
                //Here I would simply get the customer ID and pass completion along
                self.getCustomerNameFromID(customerID: jsonarr,completion: completion)
            }
        }
        }
    }
    
    /**
     Takes an orderID from the API as well as a message and updates the delivery status to that message.
     - parameter orderID: The API ID of the order.
     - parameter message: The message to be posted
     */
    func getPriceFromOrder(orderID: String, completion: @escaping (String) -> Void){
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/orders/\(Int(orderID)!).json"
        print(url)
        Alamofire.request(url, headers: headers).responseJSON { response in
            DispatchQueue.main.async {
                if let json = response.result.value{
                    let jsonarr = self.JSONtoDictionary(JSONelement: JSON(json))["price"] as! String
                    completion(jsonarr)
                }
            }
        }
    }
    
    func getIDsFromOrder(orderID: String, completion: @escaping (String, String, String) -> Void){
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/orders/\(Int(orderID)!).json"
        print(url)
        Alamofire.request(url, headers: headers).responseJSON { response in
            DispatchQueue.main.async {
            if let json = response.result.value{
                let jsonarr = self.JSONtoDictionary(JSONelement: JSON(json))["customer_id"] as! String
                let provID = self.JSONtoDictionary(JSONelement: JSON(json))["provider_id"] as! String
                let price = self.JSONtoDictionary(JSONelement: JSON(json))["price"] as! String
                //Here I would simply get the customer ID and pass completion along
                completion(jsonarr, provID, price)
            }
        }
        }
        
    }
    
    func getAccountId(userID: String, completion: @escaping (String) -> Void){
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/users/\(Int(userID)!).json"
        print(url)
        Alamofire.request(url, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = self.JSONtoDictionary(JSONelement: JSON(json))
                let finalString: String = (jsonarr["account_id"] as! String)
                //Here I would simply get the customer ID and pass completion along
                completion(finalString)
            }
        }
    }
    
    func getCustAndAcct(custID: String, acctID: String, price: String, completion: @escaping (String, String, String) -> Void){
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/users/\(Int(custID)!).json"
        let url2 = "http://germy.tk:3000/users/\(Int(acctID)!).json"
        print(url)
        Alamofire.request(url, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = self.JSONtoDictionary(JSONelement: JSON(json))
                var finalString: String = (jsonarr["custID"] as! String)
                Alamofire.request(url2, headers: headers).responseJSON { response in
                    if let json = response.result.value{
                        let jsonarr = self.JSONtoDictionary(JSONelement: JSON(json))
                        var finalString2: String = (jsonarr["account_id"] as! String)
                        completion(finalString, finalString2, price)
                    }
                }
            }
        }
    }
    
    
    func getResturauntIDFromOrder(orderID: String, lastOne: [String : Any], lOFID: [String], index: Int, completion: @escaping (String, String, String, [String : Any], [String], Int) -> Void){
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/restaurants/\(orderID).json"
        print(url)
        Alamofire.request(url, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = self.JSONtoDictionary(JSONelement: JSON(json))["name"] as! String
                let lat = self.JSONtoDictionary(JSONelement: JSON(json))["latitude"] as! String
                let long = self.JSONtoDictionary(JSONelement: JSON(json))["longitude"] as! String
                //Here I would simply get the customer ID and pass completion along
                completion(jsonarr, lat, long, lastOne, lOFID, index)
            }
        }
        
    }
    
    func getCustomerNameFromID(customerID: String, completion: @escaping (String, String) -> Void){
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/users/\(Int(customerID)!).json"
        print(url)
        Alamofire.request(url, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = self.JSONtoDictionary(JSONelement: JSON(json))
                var finalString: String = (jsonarr["first_name"] as! String)
                finalString = finalString + " " + (jsonarr["last_name"] as! String)
                //Here I would simply get the customer ID and pass completion along
                completion(finalString, customerID)
            }
        }

    }
    
    func getCustomerPhoneFromID(customerID: String, completion: @escaping (String) -> Void){
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/users/\(Int(customerID)!).json"
        print(url)
        Alamofire.request(url, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = self.JSONtoDictionary(JSONelement: JSON(json))
                let finalString: String = (jsonarr["phone"] as! String)
                //Here I would simply get the customer ID and pass completion along
                completion(finalString)
            }
        }
        
    }

    func getFoodModelFromOrder(orderID: String, index: Int, numsArray: [String],  completion: @escaping ([String], Int, [String]) -> Void) {
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        Alamofire.request("http://germy.tk:3000/food_orders.json", headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = JSON(json)
                var foodArray = [String]()
                for item in jsonarr.array!{
                    let title: String? = item["order_id"].stringValue
                    if (title == String(orderID)){
                        //Get the array of food ids
                        foodArray.append(item["food_id"].stringValue)
                        print(foodArray)
                    }
                }
                completion(numsArray, index + 1, foodArray)


    }
    
        }
        }

}
