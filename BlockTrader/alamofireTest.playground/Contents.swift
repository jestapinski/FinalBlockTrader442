//: Playground - noun: a place where people can play

import UIKit
import Foundation
import SwiftyJSON
import Alamofire

var str = "Hello, playground"

let headers = [
    "Authorization": " Token token=GhetUdTHRcOgsPwFRSyrj"
]

let arr = ["a", "b", "c"]
print(arr.joined(separator: " & "))

var foodArray = [String]()

Alamofire.request("http://germy.tk:3000/resturaunts.json", headers: headers).responseJSON { response in
    print("GOT HERE")
    print(response.data)
    if let json = response.result.value{
        let jsonarr = JSON(json)
        for item in jsonarr.array!{
            print("JSON3: \(item["food_id"].stringValue)")
            let title: String? = item["order_id"].stringValue
            if (title == String(24)){
                //Get the array of food ids
                foodArray.append(item["food_id"].stringValue)
            }
            //Map below to food and resturaunt TODO
            //self.TableData.append(title!)
            //ID below which we will pull from
            //self.TableActual.append(title!)
        }
        
    }
    
}
