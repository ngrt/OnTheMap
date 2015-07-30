//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Nawfal on 26/07/2015.
//  Copyright (c) 2015 Noufel Gouirhate. All rights reserved.
//

import Foundation

struct ParseStudentInformation {
    
    var firstName: String
    var lastName: String
    var latitude: Float
    var longitude: Float
    var mapString: String
    var mediaURL: String
    var objectId: String
    var uniqueKey: String
    
    init(dictionary: [String : AnyObject]) {
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as! String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as! Float
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as! Float
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as! String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as! String
        objectId = dictionary[ParseClient.JSONResponseKeys.ObjectID] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as! String
    }
    
    static func studentsFromResults(results: [[String : AnyObject]]) -> [ParseStudentInformation] {
        var informations = [ParseStudentInformation]()
        
        for result in results {
            informations.append(ParseStudentInformation(dictionary: result))
        }
        
        return informations
    }

}