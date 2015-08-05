//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Nawfal on 26/07/2015.
//  Copyright (c) 2015 Noufel Gouirhate. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    struct Constants {
        
        static let BaseURLSecure: String = "https://www.udacity.com/api"
    }
    
    struct Methods {
        static let Session: String = "/session"
        static let Users: String = "/users/<user_id>"
    }
    
    struct URLKeys {
        
        static let UserID = "id"
        
    }
    
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
       
    }
    
    struct JSONResponseKeys {
        //getSessionID
        static let Status = "status"
        static let Account = "account"
        static let Key = "key"
        static let Session = "session"
        static let ID = "id"
        
        //getUserData
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        
        
    }
    
}