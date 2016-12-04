//
//  GoingToCustomerViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/3/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit

class GoingToCustomerViewController: UIViewController {
    
    @IBAction func customerHasFood(sender: AnyObject){
        //Some API call
        performSegue(withIdentifier: "deliveredFood", sender: "")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "deliveredFood"){
        //POST REQUEST SOMEWHERE, make this an IBAction from the button later
        let secondViewController = segue.destination as? ProcessingPaymentViewController
        //            secondViewController?.resturaunt = self.restName
        //            secondViewController?.custName = self.custName
        //            secondViewController?.orderFoods = self.orderFoods
        //            print(secondViewController?.resturaunt)
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
