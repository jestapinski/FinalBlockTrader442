//
//  PickRestaurantViewController.swift
//  BlockTrader
//
//  Created by Jeremy Lee on 11/30/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import Foundation
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
class PickFoodViewController: UITableViewController {
    
    var custID: String = ""
    var customer: String = ""
    var credentials: [String : Any] = [:]
    var TableData:Array< String > = Array < String >()
    var Rests = [String : Any]()
    var tableTitle = [String]()
    var row: Int = 0

    
    @IBOutlet weak var cust_id: UILabel!
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = TableData[indexPath.row]
        print("cell \(TableData)")
        return cell
    }
    
    
    func do_table_refresh()
    {
        
        self.tableView.reloadData()

    }
    
    // MARK: - Navigation
    
    func moveToConfirmation(orderNumber: OrderNumber){
        performSegue(withIdentifier: "confirmation", sender: orderNumber)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "confirmation") {
            let finalDestination = segue.destination as? OrderConfirmationViewController
            finalDestination?.orderNumber = sender as! OrderNumber
            finalDestination?.custID = self.cust_id.text!
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Checking Stripe call, can remove when deployed
        // Do any additional setup after loading the view.
        
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        Alamofire.request("http://germy.tk:3000/restaurants.json", headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = JSON(json)
                for item in jsonarr.array!{
                    print("JSON1: \(item["name"].stringValue)")
                    let title: String? = item["name"].stringValue
                    self.TableData.append(title!)
                }
                self.do_table_refresh()
                
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
