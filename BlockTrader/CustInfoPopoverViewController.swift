//
//  CustInfoPopoverViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/7/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import MapKit

class CustInfoPopoverViewController: UIViewController {
    
    var resturaunt: String = ""
    var custName = ""
    var custFBID = ""
    var orderFoods = ""
    var price = ""
    var profPic: UIImage?
    var phone = ""
    
    @IBOutlet weak var custNameLocationLabel: UILabel!
    @IBOutlet weak var restNameLabel: UILabel!
    @IBOutlet weak var foodsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var profPicImg: UIImageView!
    @IBOutlet weak var phoneLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.custNameLocationLabel.text = custName
        self.restNameLabel.text = self.resturaunt
        self.priceLabel.text = self.price
        self.profPicImg.image = self.profPic!
        self.foodsLabel.text = self.orderFoods
        self.phoneLabel.text = self.phone

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
