//
//  GatheringInfoViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 11/30/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit

class GatheringInfoViewController: UIViewController {

    var credentials: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)  {
        super.viewWillAppear(animated)
        if(self.credentials["custID"] as? String == ""){
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "insertcard", sender: nil)
            }
        }else{
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "jumpToRest", sender: nil)
            }
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "insertcard"){
            let finalDestination = segue.destination as? CardViewController
            finalDestination?.credentials = self.credentials
        }
        if (segue.identifier == "jumpToRest"){
            let finalDestination = segue.destination as? PickRestarauntViewController
            finalDestination?.credentials = self.credentials
        }
    }

}
