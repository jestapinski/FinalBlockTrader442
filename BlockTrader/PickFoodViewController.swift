//
//  PickFoodViewController.swift
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
    
    var customer: String = ""
    var credentials: [String : Any] = [:]
    
    var TableData = [String: String]()
    
    var Rests = [String : Any]()
    var tableTitle = [String]()
    var row: Int = 0
    var items = [Int]()

    
    @IBOutlet weak var cust_id: UILabel!
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.textLabel?.text = TableData[Array(TableData.keys)[indexPath.row]]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        items.remove(at: items.index(of: Int(Array(TableData.keys)[indexPath.row])!)!)
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        items.append(Int(Array(TableData.keys)[indexPath.row])!)
    }
    
    func do_table_refresh()
    {
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation

    func moveToConfirmation(orderNumber: OrderNumber){
      //performSegue(withIdentifier: "confirmation", sender: orderNumber)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "submitorder") {
            let finalDestination = segue.destination as? OrderFormViewController
            finalDestination?.credentials =	 self.credentials
            finalDestination?.items = self.items
            finalDestination?.row = self.row
            finalDestination?.customer = self.customer
            
        } else if (segue.identifier == "back_to_resturaunt") {
            let finalDestination = segue.destination as? PickRestarauntViewController
            finalDestination?.credentials = self.credentials
            finalDestination?.customer = self.customer
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Checking Stripe call, can remove when deployed
        // Do any additional setup after loading the view.
        
        self.tableView.allowsMultipleSelection = true
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        let url = "http://germy.tk:3000/foods.json?rest_id=\( self.row)"
        Alamofire.request(url, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = JSON(json)
                for item in jsonarr.array!{
                    print("JSON1: \(item["name"].stringValue)")
                    let title: String? = item["name"].stringValue
                    let id: String? = item["id"].stringValue
                    self.TableData[id!] = title!
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
