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
import Alamofire
import SwiftyJSON

class MainPageViewController: UIViewController {
    
    var accessToken: AccessToken?
    var apiToken: Any?
    var credentials: [String: Any] = [:]
    
    let backendClient = BackendClient()
    
    @IBOutlet weak var welcomename: UILabel!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var buyFood: UIButton!
    @IBOutlet weak var deliverFood: UIButton!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate


    override func viewDidLoad() {
        super.viewDidLoad()
        self.processToken()
        self.buyFood.layer.cornerRadius = 60
        self.deliverFood.layer.cornerRadius = 60
        self.profPic.layer.cornerRadius = self.profPic.frame.size.width / 2
        self.profPic.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    

    /**
     Processes the Facebook API token and requests information from Facebook graph
    */
    func processToken(){
        if let accessToken = self.accessToken{
            appDelegate.accessToken = accessToken
            let params = ["fields" : "email, name, id"]
            let graphRequest = GraphRequest(graphPath: "me", parameters: params)
            self.completeGraphRequest(graphRequest: graphRequest, accessToken: accessToken)
        } else {
            self.accessToken = appDelegate.accessToken
            let params = ["fields" : "email, name, id"]
            let graphRequest = GraphRequest(graphPath: "me", parameters: params)
            self.completeGraphRequest(graphRequest: graphRequest, accessToken: self.accessToken!)
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
            
            var request = URLRequest(url: URL(string: "http://germy.tk:3000/api/signin")!)
            request.httpMethod = "POST"
            let postString = "name=\(responseDictionary["name"]!)&email=\(responseDictionary["email"]!)&fb_id=\(responseDictionary["id"]!)&accessToken=\(accessToken.authenticationToken)"
            request.httpBody = postString.data(using: .utf8)
            let img = self.backendClient.getProfilePicture(id: responseDictionary["id"] as! String)
            self.profPic.image = img
            self.handleAuthenticationRequest(request: request) //Maybe in another module?
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
                print("jsonreq")
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                self.extractAndHandleUserInfo(jsonResult: jsonResult)
                
            }catch{
                print("issue")
            }
            
        }
        task.resume()
    }
    
    // MARK: UserData Functions

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
        let custID = jsonResult!["custID"]
        //Phone may be null
        self.credentials["api_authtoken"] = ourAUTH
        self.credentials["email"] = userEmail
        self.credentials["first_name"] = userFirstName
        self.credentials["last_name"] = userLastName
        self.credentials["fb_id"] = userID
        self.credentials["phone"] = userPhone
        self.credentials["custID"] = custID
        self.appDelegate.credentials = self.credentials
        print("responseString2 = \(ourAUTH)")
        self.welcomename.text = userFirstName as? String
        print("creds: \(self.credentials)")
        let headers = [
            "Authorization": " Token token=\(self.credentials["api_authtoken"]!)"
        ]
        
        
        let url_email = "http://germy.tk:3000/users.json?email=\(self.credentials["email"]!)"
        print("\(url_email)")
        Alamofire.request(url_email, headers: headers).responseJSON { response in
            if let json = response.result.value{
                let jsonarr = JSON(json)
                for item in jsonarr.array!{
                    self.credentials["id"] = item["id"].stringValue
                    print("found ID: \(item["id"])")
                }
                self.appDelegate.credentials = self.credentials
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        appDelegate.credentials = self.credentials
        if (segue.identifier == "customer_branch"){
            let finalDestination = segue.destination as? GatheringInfoViewController
            finalDestination?.credentials = self.credentials
        } else if (segue.identifier == "deliverer_branch") {
            let finalDestination = segue.destination as? GatheringDelivererViewController
            finalDestination?.credentials = self.credentials
        }
    }

}
