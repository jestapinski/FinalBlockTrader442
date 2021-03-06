//
//  MyAPIClient.swift
//  StripeTest
//
//  Created by Jordan Stapinski on 11/15/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//  Borrowed from Stripe example provided at https://github.com/stripe/stripe-ios

import Foundation
import Stripe
import SVProgressHUD
import Alamofire


class MyAPIClient: NSObject, STPBackendAPIAdapter {
    
    static let sharedClient = MyAPIClient()
    let session: URLSession
    var baseURLString: String? = nil
    var defaultSource: STPCard? = nil
    var sources: [STPCard] = []
    var customerID: String = ""
    var stripeBackendURL: String = "http://stripetest67442.herokuapp.com"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        self.session = URLSession(configuration: configuration)
        super.init()
    }
    
    /**
     Produces a Stripe Token provided a Credit Card.
     - parameter card: A Credit Card passed according to the STPCardParams Representation
     - parameter parameters: User parameters to be passed along with creation of Stripe Account
     - parameter inst: The current instance of the CardViewController class
    */
    func getStripeToken(card:STPCardParams, parameters : [String : Any], inst: CardViewController) {
        // Get stripe token for current card through Stripe method
        STPAPIClient.shared().createToken(withCard: card) { token, error in
            if let token = token {
                SVProgressHUD.showSuccess(withStatus: "Stripe token successfully received: \(token)")
                self.postStripeToken(token: token, parameters: parameters, inst: inst)
            } else {
                print(error)
                //SVProgressHUD.showError(errorwithStatus:,, ?.localizedDescription)
            }
        }
    }
    
    /**
     Use the Stripe Backend to create a customer account given a CC token, and retrieve the customer ID.
     - parameter token: Token of payment type
     - parameter parameters: User info to be used in creating customer account
     - parameter inst: The current instance of the CardViewController class
    */
    func postStripeToken(token: STPToken, parameters: [String : Any], inst: CardViewController) {
        //Set up these params as your backend require
        //Remove hardcoding
        
        //Below line can now likely be removed from this function since purpose has changed and these are not in use
        let params: [String: NSObject] = ["stripeToken": token.tokenId as NSObject, "amount": 100 as NSObject, "acct" : "acct_19FdUmA1RWNbtIye" as NSObject, "email" : parameters["email"] as! NSObject]

        let baseUrl = URL(string: self.stripeBackendURL)
        let url = baseUrl?.appendingPathComponent("cust_new")
        let configuration = URLSessionConfiguration.default
        
        //Below line is optional
        configuration.timeoutIntervalForRequest = 5
        let session = URLSession(configuration: configuration)
        
        //Pass to backend
        Alamofire.request(stripeBackendURL + "/cust_new", method: .post, parameters: params).response { response in
            if let error = response.error {
                print("Error fetching repositories: \(error)")
                inst.handleCustomerID()
                return
            }
            print("Got something")
            let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
            print(response.data!)
            print(responseString!)
            inst.customerID = responseString as! String
            inst.handleCustomerID()
        }
    }
    
    /**
     Decodes a URL response to find any errors
     - parameter response: The URL reponse from the server
     - parameter error: The possible error
    */
    func decodeResponse(_ response: URLResponse?, error: NSError?) -> NSError? {
        if let httpResponse = response as? HTTPURLResponse
            , httpResponse.statusCode != 200 {
            return error
        }
        return error
    }
    
    /**
     Converts dollars to cents in string form
     - parameter cost: The cost in the required format of "Dollar amount.CC"
    */
    func getCents(cost: String) -> String{
        if (cost == ""){return ""}
        var newArr = cost.components(separatedBy: ".")
        if (newArr[1].characters.count == 0){
            newArr[1] = "00"
            return newArr.joined(separator: "")
        } else if (newArr[1].characters.count == 1) {
            newArr[1] = newArr[1] + "0"
            return newArr.joined(separator: "")
        } else {
            return newArr.joined(separator: "")
        }
    }
    
    /**
    Performs a Stripe charge on the customerID to the providerID with amount "cost"
    - parameter providerID: The stripe account ID of the deliverer
    - parameter customerID: The stripe customer ID of the buyer
    - parameter cost: The cost of the transaction
    - parameter completion: The completion handler
    */
    func performCharge(providerID: String, customerID: String, cost: String, completion: @escaping () -> Void){
        guard let baseURL = URL(string: stripeBackendURL) else {
            let error = NSError(domain: StripeDomain, code: 50, userInfo: [
                NSLocalizedDescriptionKey: "Please set baseURLString to your Heroku URL in CheckoutViewController.swift"
                ])
            completion()
            return
        }
        let path = "charge"
        let finalCost = self.getCents(cost: cost)
        let url = baseURL.appendingPathComponent(path)
        let params: [String: Any] = [
            "payment_id_receiever": providerID,
            "payment_id_user": customerID,
            "cost": finalCost
        ]
        let request = URLRequest.request(url, method: .POST, params: params as [String : AnyObject])
        let task = self.session.dataTask(with: request) { (data, urlResponse, error) in
            DispatchQueue.main.async {
                if let error = self.decodeResponse(urlResponse, error: error as NSError?) {
                    completion()
                    return
                }
                completion()
            }
        }
        task.resume()

    }
    
    //Base required function in STPBackendAPIAdapter. This function is required but not used
    func completeCharge(_ result: STPPaymentResult, amount: Int, completion: @escaping STPErrorBlock) {
        guard let baseURLString = baseURLString, let baseURL = URL(string: baseURLString) else {
            let error = NSError(domain: StripeDomain, code: 50, userInfo: [
                NSLocalizedDescriptionKey: "Please set baseURLString to your Heroku URL in CheckoutViewController.swift"
                ])
            completion(error)
            return
        }
        let path = "charge"
        let url = baseURL.appendingPathComponent(path)
        let params: [String: AnyObject] = [
            "source": result.source.stripeID as AnyObject,
            "amount": amount as AnyObject
        ]
        let request = URLRequest.request(url, method: .POST, params: params)
        let task = self.session.dataTask(with: request) { (data, urlResponse, error) in
            DispatchQueue.main.async {
                if let error = self.decodeResponse(urlResponse, error: error as NSError?) {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }
        task.resume()
    }
    
    /**
     Function from stripe-ios-master Github Repo which retrieves a customer. Required for STPBackendAPIAdapter but not used
    */
    @objc func retrieveCustomer(_ completion: @escaping STPCustomerCompletionBlock) {
        guard let baseURLString = baseURLString, let baseURL = URL(string: baseURLString) else {
            // This code is just for demo purposes - in this case, if the example app isn't properly configured, we'll return a fake customer just so the app works.
            let customer = STPCustomer(stripeID: "cus_test", defaultSource: self.defaultSource, sources: self.sources)
            completion(customer, nil)
            return
        }
        let path = "/customer"
        let url = baseURL.appendingPathComponent(path)
        let request = URLRequest.request(url, method: .GET, params: [:])
        let task = self.session.dataTask(with: request) { (data, urlResponse, error) in
            DispatchQueue.main.async {
                let deserializer = STPCustomerDeserializer(data: data, urlResponse: urlResponse, error: error)
                if let error = deserializer.error {
                    completion(nil, error)
                    return
                } else if let customer = deserializer.customer {
                    completion(customer, nil)
                }
            }
        }
        task.resume()
    }
    
    /**
     Function from stripe-ios-master Github Repo which retrieves a customer's default payment type. Required for STPBackendAPIAdapter but not used
     */
    @objc func selectDefaultCustomerSource(_ source: STPSource, completion: @escaping STPErrorBlock) {
        guard let baseURLString = baseURLString, let baseURL = URL(string: baseURLString) else {
            if let token = source as? STPToken {
                self.defaultSource = token.card
            }
            completion(nil)
            return
        }
        let path = "/customer/default_source"
        let url = baseURL.appendingPathComponent(path)
        let params = [
            "source": source.stripeID,
            ]
        let request = URLRequest.request(url, method: .POST, params: params as [String : AnyObject])
        let task = self.session.dataTask(with: request) { (data, urlResponse, error) in
            DispatchQueue.main.async {
                if let error = self.decodeResponse(urlResponse, error: error as NSError?) {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }
        task.resume()
    }
    
    /**
     Function from stripe-ios-master Github Repo which attaches a payment source to a customer. Required for STPBackendAPIAdapter but not used
     */
    @objc func attachSource(toCustomer source: STPSource, completion: @escaping STPErrorBlock) {
        guard let baseURLString = baseURLString, let baseURL = URL(string: baseURLString) else {
            if let token = source as? STPToken, let card = token.card {
                self.sources.append(card)
                self.defaultSource = card
            }
            completion(nil)
            return
        }
        let path = "/customer/sources"
        let url = baseURL.appendingPathComponent(path)
        let params = [
            "source": source.stripeID,
            ]
        let request = URLRequest.request(url, method: .POST, params: params as [String : AnyObject])
        let task = self.session.dataTask(with: request) { (data, urlResponse, error) in
            DispatchQueue.main.async {
                if let error = self.decodeResponse(urlResponse, error: error as NSError?) {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }
        task.resume()
    }
    
}
