//
//  StripeAccountViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 11/26/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit

class StripeAccountViewController: UIViewController {

    var baseURL: String = "http://stripetest67442.herokuapp.com"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func findAcct(sender: AnyObject){
        let authURL = self.baseURL + "/authorize"
        if let requestUrl = NSURL(string: authURL) {
            print(requestUrl)
            UIApplication.shared.openURL(requestUrl as URL)
        }
    }
    
    /**
     Performs the intended Segue to the MainSellerViewController given the account number
     - parameter accessCode: The account id provided by Stripe
    */
    func swapWindows(accessCode: String){
        performSegue(withIdentifier: "hasbeenauthenticated", sender: accessCode)
        return
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        print("HERE")
        if (segue.identifier == "hasbeenauthenticated") {
            let secondViewController = segue.destination as? MainSellerViewController
            let acctNumber = sender as! String
            secondViewController?.acctNumber = acctNumber
            print("Userinfo")
            print(acctNumber)
            //At this point we can save it to DB, changing segue to only run on setup i.e. once per user

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
