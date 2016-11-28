//
//  OrderFormViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 11/26/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit

typealias OrderNumber = Int

/**
 View controller upon which a user can submit an order
 */
class OrderFormViewController: UIViewController {
    
    var customer: String = ""
    
    @IBOutlet weak var cust_id: UILabel!
    
    @IBOutlet weak var food_choice: UITextField!
    @IBOutlet weak var resturaunt_choice: UITextField!
    @IBOutlet weak var customer_location: UITextField!
    
    //Change below to have better UX
    @IBOutlet weak var desired_price: UITextField!
    
    @IBAction func submitForm(sender: AnyObject){
        //Check if fields are valid
        if self.checkValidFields(){
            //Submit order
            let orderNumber = self.submitOrder()
            //Move to next page
            self.moveToConfirmation(orderNumber: orderNumber)
        } else {
            print("Fields are not correct")
        }
        
    }
    
    func checkValidFields() -> Bool{
        if let food = self.food_choice.text,
           let location = self.customer_location.text,
           let resturaunt = self.resturaunt_choice.text{
            return priceIsValid()
        }
        return false
    }
    
    func priceIsValid() -> Bool{
        return (self.desired_price.text != nil)
    }
    
    //TODO
    func submitOrder() -> OrderNumber{
        //Some API call to post order to DB, be sure to use cust_id
        return 1
    }
    
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
        self.cust_id.text = customer
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
