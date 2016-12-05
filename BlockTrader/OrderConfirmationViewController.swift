//
//  OrderConfirmationViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 11/28/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FacebookLogin
import FacebookCore

class OrderConfirmationViewController: UIViewController {
    
    let backendClient = BackendClient()
    var custID: String = ""
    var orderNumber: Int = 0
    var items = [Int]()
    var credentials: [String : Any] = [:]
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var order: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var name: UILabel!

    
    func execute(timer:Timer) {
        print("timer \(timer)")
        var orderNumber1 = timer.userInfo as! Int
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/orders/\(orderNumber1).json"
        Alamofire.request(url, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = JSON(json)
                self.order.text! = jsonarr["delivery_status"].stringValue
                if(jsonarr["provider_id"].stringValue != "0"){
                    
                    let url = "http://germy.tk:3000/users/\(jsonarr["provider_id"].stringValue).json"
                    Alamofire.request(url, headers: headers).responseJSON { response in
                    if let json = response.result.value{
                        let jsonarr1 = JSON(json)

                        self.name.text! = jsonarr1["first_name"].stringValue
                        print("fb \(jsonarr1["fb_id"])")
                        let img = self.backendClient.getProfilePicture(id: jsonarr1["fb_id"] as! String)
                        //self.profPic.image = img
                        }
                    }
                    
                    
                }
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customer.text = custID
        self.order.text = String(orderNumber)
        
        if(self.orderNumber != 0){
            Timer.scheduledTimer(timeInterval: 5, target: self,selector: #selector(OrderConfirmationViewController.execute), userInfo: self.orderNumber, repeats: true)
        }
        //Update labels with ID and OrderNumber to present to user

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
