//
//  AppDelegate.swift
//  BlockTrader
//
//  Created by Jordan Stapinski on 11/25/16.
//  Copyright © 2016 Jordan Stapinski. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Stripe
import FacebookCore
import FacebookLogin
import FacebookShare

// RequiredBillingAddressFields Code pulled from Stripe iOS integration example
fileprivate enum RequiredBillingAddressFields: String {
    case None = "None"
    case Zip = "Zip"
    case Full = "Full"
    
    init(row: Int) {
        switch row {
        case 0: self = .None
        case 1: self = .Zip
        default: self = .Full
        }
    }
    
    var stpBillingAddressFields: STPBillingAddressFields {
        switch self {
        case .None: return .none
        case .Zip: return .zip
        case .Full: return .full
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var credentials: [String : Any] = [:]
    var accessCode: String?
    var accessToken: AccessToken?
    let stripePublishableKey = "pk_test_BfRm3UU2gsYRebGH6cMuwnl7"
    let appleMerchantID: String? = nil
    fileprivate var requiredBillingAddressFields: RequiredBillingAddressFields = .None
    
    //Settings code pulled from Stripe-iOS-master REPO on GitHub
    struct Settings {
        let theme: STPTheme
        let additionalPaymentMethods: STPPaymentMethodType
        let requiredBillingAddressFields: STPBillingAddressFields
        let smsAutofillEnabled: Bool
    }
    
    
    var settings: Settings {
        let theme = STPTheme()
        theme.primaryBackgroundColor = UIColor(red:0.16, green:0.23, blue:0.31, alpha:1.00)
        theme.secondaryBackgroundColor = UIColor(red:0.22, green:0.29, blue:0.38, alpha:1.00)
        theme.primaryForegroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
        theme.secondaryForegroundColor = UIColor(red:0.60, green:0.64, blue:0.71, alpha:1.00)
        theme.accentColor = UIColor(red:0.98, green:0.80, blue:0.00, alpha:1.00)
        theme.errorColor = UIColor(red:0.85, green:0.48, blue:0.48, alpha:1.00)
        theme.font = UIFont(name: "GillSans", size: 17)
        theme.emphasisFont = UIFont(name: "GillSans", size: 17)
        return Settings(theme: theme,
                        additionalPaymentMethods: false ? .all : STPPaymentMethodType(),
                        requiredBillingAddressFields: self.requiredBillingAddressFields.stpBillingAddressFields,
                        smsAutofillEnabled: false)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        STPPaymentConfiguration.shared().publishableKey = "pk_test_BfRm3UU2gsYRebGH6cMuwnl7"
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    /**
     Recursively gets the current view controller being displayed
     - parameter rootViewController: The current view controller for the app
    */
    func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        
        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if rootVC?.presentedViewController == nil {
            return rootVC
        }
        
        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return getVisibleViewController(presented)
        }
        return nil
    }
    
    /**
     This function is called upon returning to the app from either a WebView or some URL
     Used for Facebook and Stripe authentications
    */
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        //Below line is to distinguish Facebook from Stripe, can be improved in the future
        if url.absoluteString[url.absoluteString.startIndex] != "s" {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        else{
            //Handle some silly entry pt
            self.accessCode = (url.host as String!)
            if let code = self.accessCode {
                let rootVC = self.getVisibleViewController(self.window!.rootViewController) as! StripeAccountViewController
                rootVC.swapWindows(accessCode: code)
            } else {
                //TODO raise some error
                print("Stripe Failed")
            }
        /**
             
        Info used for payment contexts, to be deleated later
             
        let config = STPPaymentConfiguration.shared()
        config.publishableKey = self.stripePublishableKey
        config.appleMerchantIdentifier = self.appleMerchantID
        //config.companyName = self.companyName
        config.requiredBillingAddressFields = settings.requiredBillingAddressFields
        config.additionalPaymentMethods = settings.additionalPaymentMethods
        config.smsAutofillDisabled = !settings.smsAutofillEnabled
        
        let paymentContext = STPPaymentContext(apiAdapter: MyAPIClient.sharedClient,
                                               configuration: config,
                                               theme: settings.theme)
        print("SUCCESS! Now to swap windows")
        */
            return true
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        FBSDKAppEvents.activateApp()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
//    }
    
}
