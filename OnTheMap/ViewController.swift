//
//  ViewController.swift
//  OnTheMap
//
//  Created by Nawfal on 24/07/2015.
//  Copyright (c) 2015 Noufel Gouirhate. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var session: NSURLSession!
    var sessionID: String? = nil
    let baseURLSecureString = "https://www.udacity.com/api"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = NSURLSession.sharedSession()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


    @IBAction func loginBtn(sender: AnyObject) {
        getSessionID()
        
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    func getSessionID() {
        let methodParameters = [
        ]
        
        let urlString = baseURLSecureString + "/session"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"tarioug@gmail.com\", \"password\": \"lsnear99\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) {data, response, error in
            if error != nil {
                println("Error dans sessionID")
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary

                
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
            
            urlVars += [key + "=" + "\(escapedValue)"]
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }

}

