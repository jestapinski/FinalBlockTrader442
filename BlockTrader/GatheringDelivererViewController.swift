//
//  GatheringDelivererViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 12/1/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit

class GatheringDelivererViewController: UIViewController {
    
    var credentials: [String : Any] = [:]
    let backendClient = BackendClient()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.backendClient.getAccountForUser(userID: self.credentials["id"] as! String, completion: self.checkForAccountID)
        // Do any additional setup after loading the view.
    }
    
    func checkForAccountID(isInSystem: Bool){
        if isInSystem {
            performSegue(withIdentifier: "sellerDirect", sender: "")
        } else {
            performSegue(withIdentifier: "newAuthSeller", sender: "")
        }
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
