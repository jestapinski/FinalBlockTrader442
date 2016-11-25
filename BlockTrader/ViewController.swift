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

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
        loginButton.center = view.center
        
        view.addSubview(loginButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(AccessToken.current)
        if let accessToken = AccessToken.current{
            print("HERE!")
            self.moveToMainPage(accessToken: accessToken)
        }
    }
    
    func moveToMainPage(accessToken: AccessToken){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "loggedin") as! MainPageViewController
        self.present(vc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

