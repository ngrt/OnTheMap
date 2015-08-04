//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Nawfal on 26/07/2015.
//  Copyright (c) 2015 Noufel Gouirhate. All rights reserved.
//

import Foundation
import UIKit

class ParseClient: NSObject {
    
    var studentInformation = [ParseStudentInformation]()
    var exist = false
    var objectID: String? = nil
    
    func studentExist(uniqueKey : String) {
        
        let urlString = ParseClient.Constants.BaseURLSecure + ParseClient.Methods.StudentLocation + "?where=%7B%22uniqueKey%22%3A%22\(uniqueKey)%22%7D"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { /* Handle error */ return
            } else {
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                println(parsedResult)
                
                if let results = parsedResult["results"] as? [[String: AnyObject]] {
                    println("ok1")
                    if let resultDico = results[0] as? [String: AnyObject] {
                        
                        if let objectID = resultDico["objectId"] as? String {
                            self.objectID = objectID
                        }
                        
                        if let created = resultDico["createdAt"] as? String {
                            println("ok2")
                                self.exist = true
                        } else {
                            self.exist = false // n'existe pas
                            println("ok3")
                        }

                    }
                } else {
                    self.exist = false //n'existe pas
                    println("ok4")
                }
        }
    }
        task.resume()
    }
    
    func getInfo(hostViewController: UIViewController) {
        
        let urlString = ParseClient.Constants.BaseURLSecure + ParseClient.Methods.StudentLocation + "?limit=100000000000000000"
        let url = NSURL(string: urlString)!
        
        
        let request = NSMutableURLRequest(URL: url)
        request.addValue(ParseClient.Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    println(error)
                    let alertController = UIAlertController(title: "Ooups", message: "Error in downloading", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
                        hostViewController.dismissViewControllerAnimated(true, completion: nil)
                    })
                    alertController.addAction(cancelAction)
                    
                    hostViewController.presentViewController(alertController, animated: true, completion: nil)
                })

            }
            var parsingError: NSError? = nil
            let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
            
            if let results = parsedResult[ParseClient.JSONBodyKeys.Results] as? [[String: AnyObject]] {
                
                self.studentInformation = ParseStudentInformation.studentsFromResults(results)

            }
            
        }
        task.resume()
    }
    
    func sendInfo(uniqueKey : String, firstName: String, lastName: String, mapString : String, mediaURL: String, latitude: Float, longitude: Float, hostViewController : UIViewController) {
        let urlString = ParseClient.Constants.BaseURLSecure + ParseClient.Methods.StudentLocation
        let url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue(ParseClient.Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    println(error)
                    let alertController = UIAlertController(title: "Ooups", message: "Impossible d'envoyer", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
                        hostViewController.dismissViewControllerAnimated(true, completion: nil)
                    })
                    alertController.addAction(cancelAction)
                    
                    hostViewController.presentViewController(alertController, animated: true, completion: nil)
                })
                
                
                    
                }
            
            var parsedError: NSError? = nil
            let parsingResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsedError) as! NSDictionary
            
            if let error = parsingResult["error"] as? String {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    println(error)
                    let alertController = UIAlertController(title: "Ooups", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
                        hostViewController.dismissViewControllerAnimated(true, completion: nil)
                    })
                    alertController.addAction(cancelAction)
                    
                    hostViewController.presentViewController(alertController, animated: true, completion: nil)
                })

            
            } else {
                println(NSString(data: data, encoding: NSUTF8StringEncoding))
                hostViewController.dismissViewControllerAnimated(true, completion: nil)
            }

            
        }
        task.resume()
    }
    
    func updatingLocation(uniqueKey : String, firstName: String, lastName: String, mapString : String, mediaURL: String, latitude: Float, longitude: Float, hostViewController : UIViewController) {
        
        let urlString = ParseClient.Constants.BaseURLSecure + ParseClient.Methods.StudentLocation + "/" + self.objectID!

        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    println(error)
                    let alertController = UIAlertController(title: "Ooups", message: "Impossible to send the data", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
                        hostViewController.dismissViewControllerAnimated(true, completion: nil)
                    })
                    alertController.addAction(cancelAction)
                    
                    hostViewController.presentViewController(alertController, animated: true, completion: nil)
                })

            } else {
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                if let results = parsedResult["updatedAt"] as? String {
                    
                    println("Updated at : \(results)")
                    hostViewController.dismissViewControllerAnimated(true, completion: nil)
                }

            }
        }
        task.resume()
    }

    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
    
}