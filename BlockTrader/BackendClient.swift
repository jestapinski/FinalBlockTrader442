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

class BackendClient {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var credentials : [String : Any] = [:]
    
    init(){
        self.credentials = appDelegate.credentials
    }
    
    func mapToFoodJSONs(foodIDList: [String], completion: @escaping (JSON) -> Void){
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        for id in foodIDList{
            let url = "http://germy.tk:3000/foods/\(Int(id)!).json"
            print(url)
            Alamofire.request(url, headers: headers).responseJSON { response in
                if let json = response.result.value{
                    let jsonarr = JSON(json)
                    completion(jsonarr)
                }
            }
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



    func getFoodModelFromOrder(orderID: String, completion: @escaping ([String]) -> Void) {//-> [JSON]{
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
                completion(foodArray)


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
