//
//  OrderInfoViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/2/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderInfoViewController: UIViewController {
    
    var orderFoods : [[String : Any]] = []
    let backendClient = BackendClient()
    var orderID: String = "0"
    
    //Define Outlets
    @IBOutlet weak var custNameLocationLabel: UILabel!
    @IBOutlet weak var restNameLabel: UILabel!
    @IBOutlet weak var foodsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(orderFoods)
        self.backendClient.getCustomerNameFromOrder(orderID: self.orderID, completion: self.assignCustomer)
        // Do any additional setup after loading the view.
    }
    
    func assignCustomer(_ id: String){
        self.custNameLocationLabel.text = id
        self.restNameLabel.text = self.orderFoods.first?["resturant_id"] as! String?
        self.foodsLabel.text = self.getFoods()
        //self.backendClient.getPriceFromOrder(orderID: self.orderID, completion: self.assignPrice)
    }
    
    func assignPrice(_ price: String){
        self.priceLabel.text = price
    }
    
    func getFoods()-> String{
        var finalArray = [String]()
        for foodItem in self.orderFoods{
            finalArray.append(foodItem["name"] as! String)
        }
        return finalArray.joined(separator: ", ")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func moveToConfirm(sender: AnyObject){
        performSegue(withIdentifier: "sellerconfirmed", sender: "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "sellerconfirmed"){
            //POST REQUEST SOMEWHERE, make this an IBAction from the button later
            let secondViewController = segue.destination as? SellerGoingViewController
            secondViewController?.resturaunt = self.restNameLabel.text!
            print(secondViewController?.resturaunt)
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
