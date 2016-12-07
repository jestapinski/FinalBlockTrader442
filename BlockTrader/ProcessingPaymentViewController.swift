//
//  ProcessingPaymentViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/3/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit

class ProcessingPaymentViewController: UIViewController {
    
    var price: String = ""
    
    @IBOutlet weak var priceLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        priceLbl.text = "You earned \(price)"

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
