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


class MyAPIClient: NSObject, STPBackendAPIAdapter {
    
    static let sharedClient = MyAPIClient()
    let session: URLSession
    var baseURLString: String? = nil
    var defaultSource: STPCard? = nil
    var sources: [STPCard] = []
    
    override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        self.session = URLSession(configuration: configuration)
        super.init()
    }
    
    func getStripeToken(card:STPCardParams) {
        // get stripe token for current card
        STPAPIClient.shared().createToken(withCard: card) { token, error in
            if let token = token {
                print(token)
                SVProgressHUD.showSuccess(withStatus: "Stripe token successfully received: \(token)")
                self.postStripeToken(token: token)
            } else {
                print(error)
                //SVProgressHUD.showError(errorwithStatus:,, ?.localizedDescription)
            }
        }
    }
    
    // charge money from backend
    func postStripeToken(token: STPToken) {
        //Set up these params as your backend require
        //Remove hardcoding
        let params: [String: NSObject] = ["stripeToken": token.tokenId as NSObject, "amount": 100 as NSObject, "acct" : "acct_19FdUmA1RWNbtIye" as NSObject]
        //Fix below
        let baseUrl = URL(string: "http://stripetest67442.herokuapp.com")
        let url = baseUrl?.appendingPathComponent("charge")
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        let session = URLSession(configuration: configuration)
        //Actual Charge done below after passing to backend
        let request = URLRequest.request(url!, method: .POST, params: params)
        let task = session.dataTask(with: request) { (data:Data?, urlResponse, error) in
            DispatchQueue.main.async {
                if let error = self.decodeResponse(urlResponse, error: error as NSError?) {
                    return
                } else {
                    print("Success, but will figure out in the future")
                    print(urlResponse)
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print(responseString!)
                }
            }}
        task.resume()
        
    }
    
    
    func decodeResponse(_ response: URLResponse?, error: NSError?) -> NSError? {
        if let httpResponse = response as? HTTPURLResponse
            , httpResponse.statusCode != 200 {
            return error //?? NSError.networkingError(httpResponse.statusCode)
        }
        return error
    }
    
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
    
    @objc func retrieveCustomer(_ completion: @escaping STPCustomerCompletionBlock) {
        //        guard let key = Stripe.defaultPublishableKey() , !key.contains("#") else {
        //            let error = NSError(domain: StripeDomain, code: 50, userInfo: [
        //                NSLocalizedDescriptionKey: "Please set stripePublishableKey to your account's test publishable key in CheckoutViewController.swift"
        //                ])
        //            completion(nil, error)
        //            return
        //        }
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
