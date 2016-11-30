//
//  CardViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 11/26/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import Foundation
import UIKit
import Stripe
import SVProgressHUD

//ViewController for creating user from Payment Method
class CardViewController: UIViewController, STPPaymentCardTextFieldDelegate, CardIOPaymentViewControllerDelegate {
    
    var credentials: [String : Any] = [:]
    var customerID: String = ""
    
    @IBOutlet weak var payButton: UIButton!
    var paymentTextField: STPPaymentCardTextField!
    
    let API = MyAPIClient.sharedClient

    override func viewDidLoad() {
        super.viewDidLoad()
        print(credentials)
        
        //Refactor below
        let frame1 = CGRect(x: 20, y: 150, width: self.view.frame.size.width - 40, height: 40)
        paymentTextField = STPPaymentCardTextField(frame: frame1)
        paymentTextField.center = view.center
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
        //disable payButton if there is no card information
        //payButton.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CardIOUtilities.preload()
    }
    
    @IBAction func scanCard(sender: AnyObject) {
        //open cardIO controller to scan the card
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
        
    }
    
    //TODO need to check card authentication works as expected
    @IBAction func payButtonTapped(sender: AnyObject) {
        let card = paymentTextField.cardParams
        print(card)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        //send card information to stripe to get back a token
        self.API.getStripeToken(card: card, parameters: credentials, inst: self)
//        while (self.API.customerID == "") {
//            
//        }
        print("DONE")
        print(self.customerID)
    }
    
    /**
     Handles customer ID information once it is retrieved from the backend
    */
    func handleCustomerID(){
        //Got customer ID back, now we can move to next page
        print("Actual ID")
        //Below needs to be saved to API
        print(self.customerID)
        performSegue(withIdentifier: "readyToOrder", sender: self.customerID)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "readyToOrder") {
            let finalDestination = segue.destination as? OrderFormViewController
            finalDestination?.customer = self.customerID
            finalDestination?.credentials = self.credentials
        }
    }
    
    
    //TODO fix this method, it is broken but not needed right now
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        payButton.isEnabled = true
        if textField.valid{
            payButton.isEnabled = true
        }
    }
    
    //MARK: - CardIO Methods
    
    //Allow user to cancel card scanning
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        print("user canceled")
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    //Callback when card is scanned correctly
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            let str = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
            print(str)
            
            //dismiss scanning controller
            paymentViewController?.dismiss(animated: true, completion: nil)
            
            //create Stripe card
            let card: STPCardParams = STPCardParams()
            card.number = info.cardNumber
            card.expMonth = info.expiryMonth
            card.expYear = info.expiryYear
            card.cvc = info.cvv
            
            //Send to Stripe
            self.API.getStripeToken(card: card, parameters: credentials, inst: self)
            
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
