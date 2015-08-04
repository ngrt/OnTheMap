//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Nawfal on 26/07/2015.
//  Copyright (c) 2015 Noufel Gouirhate. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class UdacityClient: NSObject {
    
    //Shared session
    var session: NSURLSession!
    
    //configuration object
    var sessionID: String? = nil
    var userID: Int? = nil
    var accesTokenFB: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()

    }
    
    func completeLogin(hostViewController: UIViewController) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let controller = hostViewController.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
            hostViewController.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    func getSessionID(hostViewController: UIViewController, email : String, password : String) {
        let urlString = UdacityClient.Constants.BaseURLSecure + "/session"
        
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = session.dataTaskWithRequest(request) {data, response, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    println(error)
                    let alertController = UIAlertController(title: "Ooups", message: "Error dans sessionID", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let cancelAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
                        hostViewController.dismissViewControllerAnimated(true, completion: nil)
                    })
                    alertController.addAction(cancelAction)
                    
                    hostViewController.presentViewController(alertController, animated: true, completion: nil)
                })
                
                println("Error dans sessionID")
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                println(parsedResult)
                
                if let error = parsedResult["status"] as? Int {
                    
                    if error == 400 {
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            println(error)
                            let alertController = UIAlertController(title: "Ooups", message: "Compte inexistant", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
                                hostViewController.dismissViewControllerAnimated(true, completion: nil)
                            })
                            alertController.addAction(cancelAction)
                            
                            hostViewController.presentViewController(alertController, animated: true, completion: nil)
                        })
                        
                    }
                }
                
                if let accountDictionary = parsedResult["account"] as? [String: AnyObject] {
                    if let userID = accountDictionary["key"] as? String {
                        self.userID = userID.toInt()!
                        self.getUserData(hostViewController)
                    }
                }
                
                if let sessionDictionary = parsedResult["session"] as? [String: AnyObject] {
                    if let sessionID = sessionDictionary["id"] as? String {
                        self.sessionID = sessionID
                        self.completeLogin(hostViewController)

                    }
                }
            }
        }
        
        task.resume()
    }

    
    func getUserData(hostViewController: UIViewController) {
        let urlString = UdacityClient.Constants.BaseURLSecure + "/users" + "/\(self.userID!)"
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        
        
        let task = session.dataTaskWithRequest(request) {data, response, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    println(error)
                    let alertController = UIAlertController(title: "Ooups", message: "Error in user Data", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let cancelAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
                        hostViewController.dismissViewControllerAnimated(true, completion: nil)
                    })
                    alertController.addAction(cancelAction)
                    
                    hostViewController.presentViewController(alertController, animated: true, completion: nil)
                })
                
                println("Error in user Data")
                
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                if let userDictionary = parsedResult["user"] as? [String: AnyObject] {
                    if let firstName = userDictionary["first_name"] as? String {
                        self.firstName = firstName
                        println(firstName)
                    }
                }
                
                if let userDictionary = parsedResult["user"] as? [String: AnyObject] {
                    if let lastName = userDictionary["last_name"] as? String {
                        self.lastName = lastName
                        println(lastName)
                    }
                }
            }
        }
        
        task.resume()
        
    }
    
    func getSessionIDFB(hostViewController: UIViewController) {
        
        let urlString = UdacityClient.Constants.BaseURLSecure + "/session"
        
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(self.accesTokenFB!)
        request.HTTPBody = "{\"facebook_mobile\": {\"access_token\": \"\(self.accesTokenFB!);\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        
        
        let task = session.dataTaskWithRequest(request) {data, response, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    println(error)
                    let alertController = UIAlertController(title: "Ooups", message: "Error dans sessionID (FB)", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let cancelAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
                        hostViewController.dismissViewControllerAnimated(true, completion: nil)
                    })
                    alertController.addAction(cancelAction)
                    
                    hostViewController.presentViewController(alertController, animated: true, completion: nil)
                })
                
                println("Error dans sessionID")
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                println(parsedResult)
                if let accountDictionary = parsedResult["account"] as? [String: AnyObject] {
                    if let userID = accountDictionary["key"] as? String {
                        self.userID = userID.toInt()!
                        self.getUserData(hostViewController)
                    }
                }
                
                if let sessionDictionary = parsedResult["session"] as? [String: AnyObject] {
                    if let sessionID = sessionDictionary["id"] as? String {
                        self.sessionID = sessionID
                        self.completeLogin(hostViewController)
                    }
                }
            }
        }
        
        task.resume()
        
    }


    func logOut(hostViewController : UIViewController) {
        
        let urlString = UdacityClient.Constants.BaseURLSecure + UdacityClient.Methods.Session
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            println(NSString(data: newData, encoding: NSUTF8StringEncoding))
            hostViewController.dismissViewControllerAnimated(true, completion: nil)
        }
        task.resume()
    }
    
   
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
    
    

}