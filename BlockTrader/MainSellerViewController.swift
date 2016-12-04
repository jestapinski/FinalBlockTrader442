//
//  MainSellerViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 11/27/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import Alamofire

/**
 ViewController upon which a deliverer can see active orders
 */
class MainSellerViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var acctNumber: String = ""
    
    @IBOutlet weak var acctLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        acctLabel.text = "Welcome, " + acctNumber
        let headers = [
            "Authorization": " Token token=\(appDelegate.credentials["api_authtoken"]!)"
        ]
        var parameters: Parameters = [
            "commit": "Update User",
            "id": "\(appDelegate.credentials["id"]!)",
            "user":[
                "account_id": acctNumber
            ]
        ]
        let edit_url = "http://germy.tk:3000/users/\(self.appDelegate.credentials["id"]!)"
        Alamofire.request(edit_url, method: .patch, parameters: parameters, headers: headers)
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
