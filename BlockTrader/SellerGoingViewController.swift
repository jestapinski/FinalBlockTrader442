//
//  SellerGoingViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/2/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit

class SellerGoingViewController: UIViewController {
    
    var resturaunt: String = ""
    var custName: String = ""
    var orderFoods : [[String : Any]] = []

    
    @IBOutlet weak var custNameLocationLabel: UILabel!
    @IBOutlet weak var restNameLabel: UILabel!
    @IBOutlet weak var foodsLabel: UILabel!
    
    func getFoods()-> String{
        var finalArray = [String]()
        for foodItem in self.orderFoods{
            finalArray.append(foodItem["name"] as! String)
        }
        return finalArray.joined(separator: "\n")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(resturaunt)
        self.restNameLabel.text = resturaunt
        self.custNameLocationLabel.text = custName
        self.foodsLabel.text = self.getFoods()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func foodHasBeenPickedUp(sender: AnyObject){
        performSegue(withIdentifier: "goToCustomer", sender: "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //if (segue.identifier == "goToCustomer"){
            //POST REQUEST SOMEWHERE, make this an IBAction from the button later
            //let secondViewController = segue.destination as? GoingToCustomerViewController
//            secondViewController?.resturaunt = self.restName
//            secondViewController?.custName = self.custName
//            secondViewController?.orderFoods = self.orderFoods
//            print(secondViewController?.resturaunt)
        //}
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
