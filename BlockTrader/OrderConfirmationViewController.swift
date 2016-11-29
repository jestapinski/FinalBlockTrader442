//
//  OrderConfirmationViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 11/28/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    var custID: String = ""
    var orderNumber: Int = 0
    
    @IBOutlet weak var customer: UILabel!
    @IBOutlet weak var order: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(custID)
        //Update labels with ID and OrderNumber to present to user
        self.customer.text = custID
        self.order.text = String(orderNumber)
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
