//
//  MainPageViewController.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 11/25/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class MainPageViewController: UIViewController {
    
    var accessToken: AccessToken?
    var credentials: [String: Any] = [:]
    
    @IBOutlet weak var welcomename: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(accessToken)
//        print("Loaded!")
        self.processToken()

        // Do any additional setup after loading the view.
    }
    
    func processToken(){
        if let accessToken = self.accessToken{
        let params = ["fields" : "email, name, id"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
        self.completeGraphRequest(graphRequest: graphRequest, accessToken: accessToken)
        }
    }
    
    // MARK: - Graph Request and Processing
    /**
     Performs Facebook Graph Request to extract user information through Facebook Login, information is then sent for later processing based on success or failure.
     - parameter graphRequest: The Graph Request to be performed.
     - parameter accessToken: The Access Token used to perform the request, through Facebook API
    */
    func completeGraphRequest(graphRequest: GraphRequest, accessToken: AccessToken){
        graphRequest.start {
            (urlResponse, requestResult) in
            
            switch requestResult {
            case .failed(let error):
                self.handleGraphError(error: error)
                break
            case .success(let graphResponse):
                self.handleGraphSuccess(graphResponse: graphResponse, accessToken: accessToken)
            }
        }
    }

    /**
     Function to handle errors if graph request fails
     - parameter error: The Graph Request error to be handled.
     */
    func handleGraphError(error: Error){
        print("error in graph request:", error)
    }
    
    /**
     Continues to execute Facebook actions given a Graph Success and some response
     - parameter graphResponse: The Graph Response from the Facebook API.
     - parameter accessToken: The Access Token used to perform the request, through Facebook API
     */
    func handleGraphSuccess(graphResponse: GraphRequest.Response, accessToken: AccessToken){
        if let responseDictionary = graphResponse.dictionaryValue {
            
            //Here is the data we get back
            print(responseDictionary)
            
            //print("\(type(of: test))")
            //print(String(test)!)
            
            var request = URLRequest(url: URL(string: "http://germy.tk:3000/api/signin")!)
            request.httpMethod = "POST"
            let postString = "name=\(responseDictionary["name"]!)&email=\(responseDictionary["email"]!)&fb_id=\(responseDictionary["id"]!)&accessToken=\(accessToken.authenticationToken)"
            request.httpBody = postString.data(using: .utf8)
            self.handleAuthenticationRequest(request: request) //Maybe in another module?
            
            //task.resume()
        }
        
    }
    
    // MARK: Authentication Requests (May move out later)
    
    /**
     Performs our Authentication check on the information received through the Facebook API.
     - parameter request: The URL request to be executed.
     */
    func handleAuthenticationRequest(request: URLRequest){
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            do{
                
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                print(jsonResult)
                self.extractAndHandleUserInfo(jsonResult: jsonResult)
                
            }catch{
                print("issue")
            }
            
        }
        task.resume()
    }
    
    // MARK: UserData

    /**
     Handles User Data given a JSONDictionary from Facebook API and our Authentication
     - parameter jsonResult: The Dictionary to be parsed.
     */
    func extractAndHandleUserInfo(jsonResult: [String: Any]?){
        let ourAUTH = jsonResult!["api_authtoken"]!
        let userEmail = jsonResult!["email"]!
        let userFirstName = jsonResult!["first_name"]!
        let userLastName = jsonResult!["last_name"]!
        let userID = jsonResult!["fb_id"]!
        let userPhone = jsonResult!["phone"]!
        //Phone may be null
        self.credentials["api_authtoken"] = ourAUTH
        self.credentials["email"] = userEmail
        self.credentials["first_name"] = userFirstName
        self.credentials["last_name"] = userLastName
        self.credentials["fb_id"] = userID
        self.credentials["phone"] = userPhone
        print("responseString = \(ourAUTH)")
        self.welcomename.text = userFirstName as? String
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Buy Food
    
    //@IBAction func
        //First, check to see if CustomerID has been created
            //If not, have them enter Credit Card and get credentials, make customer before proceeding
    
        //Next, go to some menu where you can pick out food, price, location
        //Submit request
    
    // MARK: Deliver Food
        //First, check to see if AccountID is known
            //If not, have them sign into Stripe and get it back through backend

        //Next, go to some menu where all active requests are shown
        //...
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "insertcard"){
            let finalDestination = segue.destination as? CardViewController
            finalDestination?.credentials = self.credentials
        }
    }

}
