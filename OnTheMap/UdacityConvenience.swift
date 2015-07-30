//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Nawfal on 27/07/2015.
//  Copyright (c) 2015 Noufel Gouirhate. All rights reserved.
//

import Foundation

extension UdacityClient {
    
//    func authenticateWithViewController(hostViewController: UIViewController, email : String, password : String, completionHandler: (success: Bool, errorString: String?) -> Void) {
//        self.POSTSessionID(email, password: password, completionHandler: { (success, sessionID, errorString) -> Void in
//            self.getUserID(email: email, password: password, completionHandler: { (success, userID, errorString) -> Void in
//                //getuserinfo( first name + last name)
//            })
//        }
//    
//    }
    
//    func POSTSessionID(email: String, password: String, completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
//        
//        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
//        let parameters : [String: AnyObject]
//        
//        let jsonBody: [String: AnyObject] = [
//            UdacityClient.JSONBodyKeys.Udacity: "",
//            UdacityClient.JSONBodyKeys.Username: email as String,
//            UdacityClient.JSONBodyKeys.Password: password as String
//        ]
//        
//        /* 2. Make the request */
//        taskForPOSTMethod(Methods.Session, parameters : parameters, jsonBody : jsonBody) { JSONResult, error in
//            
//            /* 3. Send the desired value(s) to completion handler */
//            if let error = error {
//                completionHandler(success: false, sessionID: nil, errorString: "Login Failed (Session ID).")
//            } else {
//                if let sessionDictionary = JSONResult[UdacityClient.JSONResponseKeys.Session] as? [String: AnyObject] {
//                    if let sessionID = sessionDictionary[UdacityClient.JSONResponseKeys.ID] as? String {
//                        completionHandler(success: true, sessionID: sessionID, errorString: nil)
//                    } else {
//                        completionHandler(success: false, sessionID: nil, errorString: "Login Failed (Session ID).")
//                    }
//                }
//
//            }
//        }
//    }
//    
//    func getUserID(email: String, password: String, completionHandler: (success: Bool, userID: Int?, errorString: String?) -> Void) {
//        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
//        let parameters : [String: AnyObject]
//        let jsonBody: [String: AnyObject] = [
//            UdacityClient.JSONBodyKeys.Udacity: "",
//            UdacityClient.JSONBodyKeys.Username: email as String,
//            UdacityClient.JSONBodyKeys.Password: password as String
//        ]
//        
//        /* 2. Make the request */
//        taskForPOSTMethod(Methods.Session, parameters : parameters, jsonBody : jsonBody) { JSONResult, error in
//            
//            /* 3. Send the desired value(s) to completion handler */
//            if let error = error {
//                completionHandler(success: false, userID: nil, errorString: "Login Failed (Session ID).")
//            } else {
//                if let sessionDictionary = JSONResult[UdacityClient.JSONResponseKeys.Account] as? [String: AnyObject] {
//                    if let userID = sessionDictionary[UdacityClient.JSONResponseKeys.Key] as? String {
//                        completionHandler(success: true, userID: userID.toInt()!, errorString: nil)
//                    } else {
//                        completionHandler(success: false, userID: nil, errorString: "Login Failed (Session ID).")
//                    }
//                }
//                
//            }
//        }
//
//    }
    
}