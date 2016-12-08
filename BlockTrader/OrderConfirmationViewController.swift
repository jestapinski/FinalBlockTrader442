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
    var credentials: [String : Any] = [:]
    var fb_url: String = ""
    var refreshControl: UIRefreshControl!
    var tim: Timer?
    var status: String = ""
    
    @IBOutlet weak var order: UILabel!
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var loading: UIImageView!
    @IBOutlet weak var fbmsg: UIButton!

    @IBAction func didTapFB(sender: AnyObject) {
        if(fb_url != ""){
            UIApplication.shared.openURL(NSURL(string: fb_url) as! URL)
        }else{
            print("no fb url")
        }
    }
    func sup(notification: Notification) {
        print("none")
    }
    
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
                if(jsonarr["delivery_status"].stringValue != ""){
                    self.order.text! = jsonarr["delivery_status"].stringValue
                }else{
                    self.order.text! = "Waiting for a user to accept this order."
                }
                if(jsonarr["delivery_status"].stringValue == "Delivered"){
                    let alert = UIAlertController(title: "Item Delivered", message: "Redirecting to home", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "backHome", sender: nil)
                    }
                }
                print("status: \(self.status)")
                if(self.status != jsonarr["delivery_status"].stringValue){
                    print("status change")
                    // Define identifier
                    let notificationName = Notification.Name("\(jsonarr["deliver_status"])")
                    
                    // Register to receive notification
                    NotificationCenter.default.addObserver(self, selector: #selector(OrderConfirmationViewController.sup), name: notificationName, object: nil)
                    
                    // Post notification
                    NotificationCenter.default.post(name: notificationName, object: nil)
                    
                    // Stop listening notification
                    NotificationCenter.default.removeObserver(self, name: notificationName, object: nil);
                    self.status = jsonarr["delivery_status"].stringValue
                }
                
                
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
                            self.fb_url = "https://www.facebook.com/\(jsonarr1["fb_id"])"
                            self.fbmsg.setTitle("Facebook Messenger", for: .normal)
                        }
                    }
                }
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text = ""
        self.fbmsg.setTitle("", for: .normal)
        self.profPic.layer.cornerRadius = self.profPic.frame.size.width / 2
        self.profPic.clipsToBounds = true
        if(self.orderNumber != 0){
            self.tim = Timer.scheduledTimer(timeInterval: 5, target: self,selector: #selector(OrderConfirmationViewController.execute), userInfo: self.orderNumber, repeats: true)
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


        }else if (segue.identifier == "backHome2"){
            self.tim!.invalidate()
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "backHome", sender: nil)
            }
        }else if (segue.identifier == "orderLocation"){
            let finalDestination = segue.destination as? OrderLocationViewController
            finalDestination?.orderNumber = self.orderNumber
            finalDestination?.credentials =	 self.credentials
            finalDestination?.custID = self.custID
            finalDestination?.fb_url = self.fb_url
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
