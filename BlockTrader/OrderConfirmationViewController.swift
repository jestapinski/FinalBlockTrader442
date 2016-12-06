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
import AlamofireImage

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
//
//    @IBAction func didTapFB(sender: AnyObject) {
//        UIApplication.sharedApplication().openURL(NSURL(string: "fb-messenger://user-thread/\(jsonarr1["fb_id"])")!)
//    }
    
    
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
                        Alamofire.request("https://graph.facebook.com/v2.8/\(jsonarr1["fb_id"])/picture?width=500&height=500").responseImage { response in
                            if let image = response.result.value {
                               self.profPic.image = image
                            }
                        }
                    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "backHome"){
            let finalDestination = segue.destination as? MainPageViewController
            finalDestination?.credentials = self.credentials
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
