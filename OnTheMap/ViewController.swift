//
//  ViewController.swift
//  OnTheMap
//
//  Created by Nawfal on 24/07/2015.
//  Copyright (c) 2015 Noufel Gouirhate. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var session: NSURLSession!
    var sessionID: String? = nil
    var userID: Int? = nil
    var accesTokenFB: String? = nil
    let baseURLSecureString = "https://www.udacity.com/api"
    
    var firstName: String? = nil
    var lastName: String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = NSURLSession.sharedSession()
        
        fbConnection()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @IBAction func signUpBtn(sender: AnyObject) {
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    

    @IBAction func loginBtn(sender: AnyObject) {
        getSessionID()
    }
    
    @IBOutlet weak var loginFBBtn: FBSDKLoginButton!
    
    //https://www.youtube.com/watch?v=cpANieebE2M
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil {
            self.accesTokenFB = FBSDKAccessToken.currentAccessToken().tokenString
            getSessionIDFB()
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                println(error)
                let alertController = UIAlertController(title: "Ooups", message: "Error with Facebook connection", preferredStyle: UIAlertControllerStyle.Alert)
                
                let cancelAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alertController.addAction(cancelAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            })

        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User logged out...")
    }
    
    
    func fbConnection() {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            println("Not logged in..")
        } else {
            println("Logged in..")
            getSessionIDFB()
        }
        
        loginFBBtn.readPermissions = ["public_profile", "email"]
        loginFBBtn.delegate = self
    
    }
    
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    func getSessionID() {
        let urlString = baseURLSecureString + "/session"

        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(self.emailTextField.text)\", \"password\": \"\(self.passwordTextField.text)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        

        let task = session.dataTaskWithRequest(request) {data, response, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    println(error)
                    let alertController = UIAlertController(title: "Ooups", message: "Error dans sessionID", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let cancelAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                    alertController.addAction(cancelAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
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
                                self.dismissViewControllerAnimated(true, completion: nil)
                            })
                            alertController.addAction(cancelAction)
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                        })

                    }
                }
                
                if let accountDictionary = parsedResult["account"] as? [String: AnyObject] {
                    if let userID = accountDictionary["key"] as? String {
                        self.userID = userID.toInt()!
                        self.getUserData()
                    }
                }
                
                if let sessionDictionary = parsedResult["session"] as? [String: AnyObject] {
                    if let sessionID = sessionDictionary["id"] as? String {
                        self.sessionID = sessionID
                        self.completeLogin()
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func getUserData() {
        let urlString = baseURLSecureString + "/users" + "/\(self.userID!)"
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        
        
        let task = session.dataTaskWithRequest(request) {data, response, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    println(error)
                    let alertController = UIAlertController(title: "Ooups", message: "Error in user Data", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let cancelAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                    alertController.addAction(cancelAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                })

                println("Error in user Data")
                
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                if let userDictionary = parsedResult["user"] as? [String: AnyObject] {
                    if let firstName = userDictionary["first_name"] as? String {
                        self.firstName = firstName
                        println(self.firstName)
                    }
                }
                
                if let userDictionary = parsedResult["user"] as? [String: AnyObject] {
                    if let lastName = userDictionary["last_name"] as? String {
                        self.lastName = lastName
                        println(self.lastName)
                    }
                }
            }
        }
        
        task.resume()

    }
    
    
    func getSessionIDFB() {
        
        let urlString = baseURLSecureString + "/session"
        
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        println("{\"facebook_mobile\": {\"access_token\": \"\(self.accesTokenFB!);\"}}")
        request.HTTPBody = "{\"facebook_mobile\": {\"access_token\": \"\(self.accesTokenFB!);\"}}".dataUsingEncoding(NSUTF8StringEncoding)

        
        
        let task = session.dataTaskWithRequest(request) {data, response, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    println(error)
                    let alertController = UIAlertController(title: "Ooups", message: "Error dans sessionID (FB)", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let cancelAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                    alertController.addAction(cancelAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
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
                        self.getUserData()
                    }
                }
                
                if let sessionDictionary = parsedResult["session"] as? [String: AnyObject] {
                    if let sessionID = sessionDictionary["id"] as? String {
                        self.sessionID = sessionID
                        self.completeLogin()
                    }
                }
            }
        }
        
        task.resume()

    }
    
    func escapedParameters(parameters : [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            let stringValue = "\(value)"
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }

}

