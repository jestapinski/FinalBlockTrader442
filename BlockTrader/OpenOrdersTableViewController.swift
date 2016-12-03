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
    //Data that is shown
    var TableData = [String]()
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
    
    func getFoodOrders(_ listOfOrders: [[String : Any]]){
        let newlistOfOrders = listOfOrders.filter({$0["provider_id"] as! String != ""})
        self.TableData = newlistOfOrders.map({return $0["id"] as! String})
        self.foodOrdersLoop(self.TableData.map({$0}), 0, [])
    }
    
    //Find corresponding food orders by calling backend function on each one and agg. results
    func foodOrdersLoop(_ arr: [String], _ index: Int, _ lastBack: [String]){
        if (index != 0) {
            foodIDs.append(lastBack)
        }
        if (index == arr.count) {self.aggregateFoodItems(Array(self.foodIDs.joined()), 0, [:])
                                return}
        self.backendClient.getFoodModelFromOrder(orderID: arr[index], index: index, numsArray: arr ,completion: self.foodOrdersLoop)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.credentials = appDelegate.credentials
        print(self.credentials)
        self.backendClient.getOrders(completion: self.getFoodOrders)
//        let headers = [
//            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
//        ]
//        Alamofire.request("http://germy.tk:3000/orders.json", headers: headers).responseJSON { response in
//            if let json = response.result.value{
//                let jsonarr = JSON(json)
//                for item in jsonarr.array!{
//                    print("JSON1: \(item["id"].stringValue)")
//                    let title: String? = item["id"].stringValue
//                    let provider = item["provider"].stringValue
//                    //Map below to food and resturaunt TODO
//                    if provider == "" {
//                        self.TableData.append(title!)
//                    }
//                    //ID below which we will pull from
//                    //self.TableActual.append(title!)
//                }
//                //Perform a map to food using food_orders
//                //self.TableDisplay = self.TableData.map({self.backendClient.jsonsToNiceDisplay(jsonFoods: (self.backendClient.getFoodModelFromOrder(orderID: $0)))})
//                
//                //self.TableActual = self.TableData.map({self.backendClient.getFoodModelFromOrder(orderID: $0)})
////                for id in self.TableData{
////                    self.backendClient.getFoodModelFromOrder(orderID: id, completion: self.aggregateFoodItems)
////                }
//                print(self.foodIDs)
////                for foodList in self.foodIDs{
////                    self.backendClient.mapToFoodJSONs(foodIDList: foodList, completion: self.aggregateFoodJsons)
////                }
////                print(self.TableActual)
//                //self.do_table_refresh()
//                
            //}
        //}
        


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func aggregateFoodItems(_ listOfFoodIds: [String], _ index: Int, _ lastOne: [String : Any]){
//        self.foodIDs.append(listOfFoodIds)
        //Takes in flattened ids, now to loop
        if (index != 0) {
            allJSONs.append(lastOne)
        }
        if (index == listOfFoodIds.count) {self.combineBack()
            return}
        //Fix below and function in client
        self.backendClient.mapToFoodJSONs(foodID: listOfFoodIds[index], index: index, originalArray: listOfFoodIds , completion: self.aggregateFoodItems)
    }
    
    func aggregateFoodJsons(_ listOfFoodJsons: JSON){
        var finalJSON = backendClient.JSONtoDictionary(JSONelement: listOfFoodJsons)
        self.TableActual.append(finalJSON)
        //Need to convert below to dictionary
        
        self.TableDisplay.append(finalJSON["name"] as! String)
        print(self.TableDisplay)
        // IF this size is the expected size then we donzo
//        print(self.TableActual)
    }
    
    func setUpTables(){
        
    }
    
    func combineBack(){
        var countIDs = self.foodIDs.map({$0.count})
        var finalNames: [[String]] = []
        var finalJSONs: [[[String : Any]]] = []
        var currentIndex = 0
        //        var filteredForNames = self.TableDisplay.filter({$0 != ""})
        for countNum in countIDs {
            var newArray: [String] = []
            var newJSONArray: [[String : Any]] = []
            for i in currentIndex..<(currentIndex + countNum) {
                print(i)
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
//        self.TableDisplay
        return
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        print("FINAL")
//        print(self.foodIDs)
//        print(self.TableDisplay)
//        print(self.TableActual)
//        //Map to count and group
//        var countIDs = self.foodIDs.map({$0.count})
//        var finalNames: [[String]] = []
//        var finalJSONs: [[[String : Any]]] = []
//        var currentIndex = 0
//        var filteredForNames = self.TableDisplay.filter({$0 != ""})
//        for countNum in countIDs {
//            var newArray: [String] = []
//            var newJSONArray: [[String : Any]] = []
//            for i in currentIndex..<(currentIndex + countNum) {
//                print(i)
//                newArray.append(filteredForNames[i])
//                newJSONArray.append(self.TableActual[i])
//            }
//            currentIndex = currentIndex + countNum
//            finalNames.append(newArray)
//            finalJSONs.append(newJSONArray)
//            
//        }
//        print(self.TableDisplay)
//        print("FinalNames")
//        print(finalNames)
//        //Fix below later
//        let finalNameMapping = finalNames.map({ (x : [String]) -> String in  if x.count == 0 {return "Not Active"} else {return x.joined(separator: " & ")}})
//        print(finalNameMapping)
//        self.TableDisplay = finalNameMapping
//        self.TableJSONs = finalJSONs
//        self.do_table_refresh()
//        self.TableDisplay
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
            for i in 0..<(TableData.count){
                print(i)
                self.TableDisplay.append("")
            }
        }
        //cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.textLabel?.text = TableDisplay[indexPath.row]
        
        return cell

        // Configure the cell...

        // return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row + 1	)")
        self.indexRow = indexPath.row + 1
        print(self.TableData[indexPath.row])
        self.moveToInfoPage(rowNum: indexPath.row)
        //self.moveToConfirmation()
    }
    
    func moveToInfoPage(rowNum: Int){
        //let orderID = self.TableData[rowNum]
        print("Moving to info page")
        print(self.TableData[rowNum])
        print(self.TableJSONs[rowNum])
        self.selectedOrderInfo = self.TableJSONs[rowNum]
        //JSON list of foods
        performSegue(withIdentifier: "ViewOrderInfo", sender: rowNum)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "ViewOrderInfo") {
            let secondViewController = segue.destination as? OrderInfoViewController
//            let acctNumber = sender as! String
            secondViewController?.orderFoods = self.selectedOrderInfo
            secondViewController?.orderID = self.TableData[sender as! Int]
//            print("Userinfo")
//            print(acctNumber)
            //At this point we can save it to DB, changing segue to only run on setup i.e. once per user
            
        }
    }

    
    func do_table_refresh()
    {
        self.tableView.reloadData()
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
