//
//  ViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 11/25/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class ViewController: UIViewController {
    
    @IBOutlet weak var proceedButton: UIButton!

    // Create FaceBook login button using module and place in center
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
        loginButton.center = view.center
        view.addSubview(loginButton)
        self.proceedButton.layer.cornerRadius = 30
    }
    
    @IBAction func proceed(){
        if let accessToken = AccessToken.current{
            self.moveToMainPage(accessToken: accessToken)
        } else {
            let alert = UIAlertController(title: "Please Login", message: "Please login to Facebook to proceed", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    /**
     Function checks if authenticated through FaceBook, if so, move on.
     
    */
    override func viewDidAppear(_ animated: Bool) {
        if let accessToken = AccessToken.current{
            self.moveToMainPage(accessToken: accessToken)
        } else {
            //self.viewDidAppear(true)
        }
    }

    /**
     Performs Navigation to Home Page if the user has been authenticated through Facebook
     - parameter accessToken: The Access Token received from Facebook API
     */
    func moveToMainPage(accessToken: AccessToken){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : MainPageViewController = mainStoryboard.instantiateViewController(withIdentifier: "loggedin") as! MainPageViewController
        vc.accessToken = accessToken
        self.present(vc, animated: true, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

