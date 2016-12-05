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
    
    func getProfilePicture(id: String) -> UIImage{
        let imgURLString = "http://graph.facebook.com/" + "v2.8/" + id + "/picture?type=large" //type=normal
        let imgURL = NSURL(string: imgURLString)
        let imageData = NSData(contentsOf: imgURL! as URL)
        let image = UIImage(data: imageData! as Data)
        return image!
    }
    
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
    
//    func getFacebookPicFromID(facebookID: String, request: URLRequest, completion: @escaping (UIImage, URLRequest) -> Void){
//    Alamofire.request("graph.facebook.com/v2.8/696776167167123/image").responseImage {
//        response in
//        completion(UIImage(response.result.value, scale:1)!, request)
//        }
//    }
    
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
    
    func postProviderID(userID: String, orderID: String){
        let headers = [
            "Authorization": " Token token=\(appDelegate.credentials["api_authtoken"]!)"
        ]
        
        
        var parameters: Parameters = [
            "commit": "Update Order",
            "id": orderID,
            "order":[
                "provider_id": userID
            ]
        ]
        let edit_url = "http://germy.tk:3000/orders/" + orderID
        Alamofire.request(edit_url, method: .patch, parameters: parameters, headers: headers)

    }
    
    func mapToFoodJSONs(foodID: String, index: Int, originalArray: [String], completion: @escaping ([String], Int, [String : Any]) -> Void){
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
//        for id in foodIDList{
            let url = "http://germy.tk:3000/foods/\(Int(foodID)!).json"
            print(url)
            Alamofire.request(url, headers: headers).responseJSON { response in
                if let json = response.result.value{
                    let jsonarr = JSON(json)
                    completion(originalArray, index + 1, self.JSONtoDictionary(JSONelement: jsonarr))
                }
//            }
//    Alamofire.request("http://germy.tk:3000/food_orders.json", headers: headers).responseJSON { response in
//            if let json = response.result.value{
//                let jsonarr = JSON(json)
//                var finalArray = [JSON]()
//                for item in jsonarr.array!{
//                    print("JSON4: \(item["id"].stringValue)")
//    let title: String? = item["order_id"].stringValue
//    if (title == String(orderID)){
//    //Get the array of food ids
//    foodArray.append(item["food_id"].stringValue)
//    print(foodArray)
//    }
    //Map below to food and resturaunt TODO
    //self.TableData.append(title!)
    //ID below which we will pull from
    //self.TableActual.append(title!)
    }
    //completion(foodArray)
    
    
    }
    
    func JSONtoDictionary(JSONelement: JSON) -> [String : Any]{
        var finalDictionary : [String : Any] = [:]
        for (key, object) in JSONelement {
            finalDictionary[key] = object.stringValue
        }
        return finalDictionary
    }
    
    //Price is not in schema yet
    func getPriceFromOrder(orderID: String, completion: @escaping (String) -> Void){
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/orders/\(Int(orderID)!).json"
        print(url)
        Alamofire.request(url, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = self.JSONtoDictionary(JSONelement: JSON(json))["price"] as! String
                //Here I would simply get the customer ID and pass completion along
                completion(jsonarr)
            }
        }

    }
    
    func getOrders(completion: @escaping ([[String : Any]]) -> Void){
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/orders.json"
        print(url)
        var finalArray = [[String : Any]]()
        Alamofire.request(url, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = JSON(json)
                //                var foodArray = [String]()
                for item in jsonarr.array!{
                    //                    print("JSON3: \(item["food_id"].stringValue)")
                    //let title: String? = item["order_id"].stringValue
                    //if (title == String(orderID)){
                    //Get the array of food ids
                    finalArray.append(self.JSONtoDictionary(JSONelement: item))
                    //  print(foodArray)
                    //}
                }
                
            }
            completion(finalArray)
        }
    }

    
    func getCustomerNameFromOrder(orderID: String, completion: @escaping (String, String) -> Void){
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/orders/\(Int(orderID)!).json"
        print(url)
        Alamofire.request(url, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = self.JSONtoDictionary(JSONelement: JSON(json))["customer_id"] as! String
                //Here I would simply get the customer ID and pass completion along
                self.getCustomerNameFromID(customerID: jsonarr,completion: completion)
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
            if let json = response.result.value{
                let jsonarr = self.JSONtoDictionary(JSONelement: JSON(json))["customer_id"] as! String
                let provID = self.JSONtoDictionary(JSONelement: JSON(json))["provider_id"] as! String
                let price = self.JSONtoDictionary(JSONelement: JSON(json))["price"] as! String
                //Here I would simply get the customer ID and pass completion along
                completion(jsonarr, provID, price)
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
                //finalString = finalString + " " + (jsonarr["last_name"] as! String)
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
                        //finalString = finalString + " " + (jsonarr["last_name"] as! String)
                        //Here I would simply get the customer ID and pass completion along
                        completion(finalString, finalString2, price)
                    }
                }
            }
                //finalString = finalString + " " + (jsonarr["last_name"] as! String)
                //Here I would simply get the customer ID and pass completion along
                //completion(finalString, customerID)
        }
    }
    
    
    func getResturauntIDFromOrder(orderID: String, completion: @escaping (String, String, String) -> Void){
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
                completion(jsonarr, lat, long)
            }
        }
        
    }
    
    //Need to fix DB fields before can finish
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
    
    /*func getCustomers(customerID: String, completion: @escaping (String) -> Void){
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/users/4.json"
        print(url)
        Alamofire.request(url, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = self.JSONtoDictionary(JSONelement: JSON(json)) as! String
                //Here I would simply get the customer ID and pass completion along
                completion(jsonarr)
            }
        }
        
    }*/
    



    func getFoodModelFromOrder(orderID: String, index: Int, numsArray: [String],  completion: @escaping ([String], Int, [String]) -> Void) {//-> [JSON]{
        var foodArray = [String]()
        var finalArray = [JSON]()
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        Alamofire.request("http://germy.tk:3000/food_orders.json", headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = JSON(json)
                var foodArray = [String]()
                for item in jsonarr.array!{
//                    print("JSON3: \(item["food_id"].stringValue)")
                    let title: String? = item["order_id"].stringValue
                    if (title == String(orderID)){
                        //Get the array of food ids
                        foodArray.append(item["food_id"].stringValue)
                        print(foodArray)
                    }
                    //Map below to food and resturaunt TODO
                    //self.TableData.append(title!)
                    //ID below which we will pull from
                    //self.TableActual.append(title!)
                }
                completion(numsArray, index + 1, foodArray)


    }
    
        }
        //After Alamofire 1
//        for elem in foodArray{
//        Alamofire.request("http://germy.tk:3000/food.json", headers: headers).responseJSON { response in
//            if let json = response.result.value{
//                let jsonarr = JSON(json)
//                for item in jsonarr.array!{
//                    print("JSON2: \(item)")
//                    if (elem == item["id"].stringValue){
//                        //Get the array of food ids
//                        finalArray.append(item)
//                    }
//                }
//            }
//        }
        }
        //return finalArray
    //}
    
    func jsonsToNiceDisplay(jsonFoods: [JSON]) -> String{
        if let firstFood = jsonFoods.first {
            let resturaunt = firstFood["resturaunt"].stringValue
            var foodString = ""
            for foodItem in jsonFoods{
                foodString += foodItem["name"].stringValue + " "
            }
            return foodString + "at " + resturaunt
        } else {
            return "No such food"
        }

    }
}
