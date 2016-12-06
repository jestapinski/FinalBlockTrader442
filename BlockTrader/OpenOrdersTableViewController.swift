//
//  OpenOrdersTableViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 11/28/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class OpenOrdersTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var TableData = [String]()
    //Data that is shown

    var TableDisplay = [String]()
    //Data that is actually behind the scenes
    var TableActual : [[String : Any]] = []
    var TableJSONs : [[[String : Any]]] = []
    var indexRow: Int = 0
    var credentials: [String: Any] = [:]
    let backendClient = BackendClient()
    var selectedOrderInfo: [[String: Any]] = []
    var foodIDs: [[String]] = []
    var allJSONs: [[String : Any]] = []
    var orderDicts: [[String : Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.credentials = appDelegate.credentials
        self.backendClient.getOrders(completion: self.getFoodOrders)
    }
    
    /**
     Finds all food orders that have not been claimed by a deliverer and loops through to find order params
     - parameter listOfOrders: list of the orders in the DB
    */
    func getFoodOrders(_ listOfOrders: [[String : Any]]){
        let newlistOfOrders = listOfOrders.filter({$0["provider_id"] as! String == "0"})
        self.orderDicts = newlistOfOrders
        self.TableData = newlistOfOrders.map({return $0["id"] as! String})
        self.foodOrdersLoop(self.TableData.map({$0}), 0, [])
    }
    
    /**
        Find corresponding food orders by calling backend function on each one and agg. results
        - parameter arr: The list of orderIDs
        - parameter index: The current index we want to look at in terms of orderID
        - parameter lastBack: the result of the API call that we wish to hang onto
    */
    func foodOrdersLoop(_ arr: [String], _ index: Int, _ lastBack: [String]){
        if (index != 0) {
            foodIDs.append(lastBack)
        }
        if (index == arr.count) {self.aggregateFoodItems(Array(self.foodIDs.joined()), 0, [:])
                                return}
        self.backendClient.getFoodModelFromOrder(orderID: arr[index], index: index, numsArray: arr ,completion: self.foodOrdersLoop)

    }
    
    /**
     Takes all food IDs and returns them mapped to their models
     - parameter listOfFoodIds: List of food IDs
     - parameter index: The index of the listOfFoodIds we are looking at
     - parameter lastOne: The last value returned by the API call. A food JSON
     */
    func aggregateFoodItems(_ listOfFoodIds: [String], _ index: Int, _ lastOne: [String : Any]){
        //Takes in flattened ids, now to loop
        if (index != 0) {
            allJSONs.append(lastOne)
        }
        if (index == listOfFoodIds.count) {self.combineBack()
            return}
        //Fix below and function in client
        self.backendClient.mapToFoodJSONs(foodID: listOfFoodIds[index], index: index, originalArray: listOfFoodIds , completion: self.aggregateFoodItems)
    }
    
    /**
     Appends items for use in processing later
     - parameter listOfFoodJsons: The list of food JSON items
    */
    func aggregateFoodJsons(_ listOfFoodJsons: JSON){
        var finalJSON = backendClient.JSONtoDictionary(JSONelement: listOfFoodJsons)
        self.TableActual.append(finalJSON)
        self.TableDisplay.append(finalJSON["name"] as! String)
    }
    
    /**
     Maps the food JSONs to be the "Form" of the orders they should be in, organizes by order
    */
    func combineBack(){
        let countIDs = self.foodIDs.map({$0.count})
        var finalNames: [[String]] = []
        var finalJSONs: [[[String : Any]]] = []
        var currentIndex = 0
        for countNum in countIDs {
            var newArray: [String] = []
            var newJSONArray: [[String : Any]] = []
            for i in currentIndex..<(currentIndex + countNum) {
                //print(i)
                newArray.append(allJSONs[i]["name"] as! String)
                newJSONArray.append(allJSONs[i])
            }
            currentIndex = currentIndex + countNum
            finalNames.append(newArray)
            finalJSONs.append(newJSONArray)

        }
        let finalNameMapping = finalNames.map({ (x : [String]) -> String in  if x.count == 0 {return "Not Active"} else {return x.joined(separator: " & ")}})
        self.TableDisplay = finalNameMapping
        self.TableJSONs = finalJSONs
        self.do_table_refresh()
        return
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TableData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if (self.TableDisplay.count == 0){
            for _ in 0..<(TableData.count){
                self.TableDisplay.append("")
            }
        }
        cell.textLabel?.text = TableDisplay[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexRow = indexPath.row + 1
        self.moveToInfoPage(rowNum: indexPath.row)
    }
    
    /**
     Moves to the Order Info page, we also want the details for the order we selected
     - parameter rowNum: the row number the user selected
    */
    func moveToInfoPage(rowNum: Int){
        self.selectedOrderInfo = self.TableJSONs[rowNum]
        performSegue(withIdentifier: "ViewOrderInfo", sender: rowNum)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "ViewOrderInfo") {
            let secondViewController = segue.destination as? OrderInfoViewController
            secondViewController?.orderFoods = self.selectedOrderInfo
            secondViewController?.orderID = self.TableData[sender as! Int]
            secondViewController?.orderDict = self.orderDicts[sender as! Int]
        }
    }

    // MARK: - Table Abstractions
    
    func do_table_refresh()
    {
        self.tableView.reloadData()
    }

}
