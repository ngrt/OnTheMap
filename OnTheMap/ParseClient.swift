//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Nawfal on 26/07/2015.
//  Copyright (c) 2015 Noufel Gouirhate. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    var studentInformation: [ParseStudentInformation]?
    
    
    func getInfo(completionHandler: (result: [ParseStudentInformation]?, error: NSError?) -> Void) {
        
        let urlString = ParseClient.Constants.BaseURLSecure + ParseClient.Methods.StudentLocation
        let url = NSURL(string: urlString)!
        
        
        let request = NSMutableURLRequest(URL: url)
        request.addValue(ParseClient.Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                completionHandler(result: nil, error: error)
            }
            var parsingError: NSError? = nil
            let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
            
            if let results = parsedResult[ParseClient.JSONBodyKeys.Results] as? [[String: AnyObject]] {
                
                var informations = ParseStudentInformation.studentsFromResults(results)
                self.studentInformation = informations
                completionHandler(result: informations, error: nil)
                
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