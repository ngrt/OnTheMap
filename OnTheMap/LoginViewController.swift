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

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    
    var session: NSURLSession!
    
    var firstName: String? = nil
    var lastName: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = NSURLSession.sharedSession()
        
        fbConnection()
        
        passwordTextField.delegate = self

    }

    @IBAction func signUpBtn(sender: AnyObject) {
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    

    @IBAction func loginBtn(sender: AnyObject) {
        UdacityClient.sharedInstance().getSessionID(self, email: emailTextField.text!, password: passwordTextField.text!)
        ParseClient.sharedInstance().getInfo(self)
    }
    
    @IBOutlet weak var loginFBBtn: FBSDKLoginButton!
    
    //https://www.youtube.com/watch?v=cpANieebE2M
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil {

            UdacityClient.sharedInstance().accesTokenFB = FBSDKAccessToken.currentAccessToken().tokenString
            UdacityClient.sharedInstance().getSessionIDFB(self)
            ParseClient.sharedInstance().getInfo(self)
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                println(error.localizedDescription)
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
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            println("Not logged in..")
        } else {
            println("Logged in..")
        }
        
        loginFBBtn.readPermissions = ["public_profile", "email"]
        loginFBBtn.delegate = self
    
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        loginBtn(self)
        return true
    }

}

