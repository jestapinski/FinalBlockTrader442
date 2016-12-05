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

class OrderConfirmationViewController: UIViewController {
    
    var custID: String = ""
    var orderNumber: Int = 0
    var items = [Int]()
    var credentials: [String : Any] = [:]
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var order: UILabel!
    @IBOutlet weak var orderStatus: UILabel!

    func execute() {
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/orders.json?\( self.orderNumber)"
        Alamofire.request(url, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = JSON(json)
                for item in jsonarr.array!{
                    print("JSON2: \(item["delivery_status"].stringValue)")
                    self.order.text! = item["delivery_status"].stringValue
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var timer = Timer.scheduledTimer(timeInterval: 5, target: self,selector: #selector(OrderConfirmationViewController.execute), userInfo: nil, repeats: true)

        //Update labels with ID and OrderNumber to present to user
        self.customer.text = custID
        self.order.text = String(orderNumber)
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
