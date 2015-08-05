//
//  TableViewController.swift
//  
//
//  Created by Nawfal on 30/07/2015.
//
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class TableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var refreshData : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: Selector("reloadData:"))
        var postData : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("postStudent:"))
        
        
        var buttons : NSArray = [postData, refreshData]
        
        self.navigationItem.rightBarButtonItems = buttons as! [UIBarButtonItem]

        tableView.reloadData()
        ParseClient.sharedInstance().studentExist(String(UdacityClient.sharedInstance().userID!))
        
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func reloadData(sender: AnyObject) {
        tableView.reloadData()
    }
    
    @IBAction func logout(sender: AnyObject) {
        UdacityClient.sharedInstance().logOut(self)
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        returnToLoginPage()
        
    }
    
    func returnToLoginPage() {
        
        let nextController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginPage") as! LoginViewController
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = nextController
    }

    

    func postStudent(sender: AnyObject) {
        if ParseClient.sharedInstance().exist == true {
            println("existe")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let alertController = UIAlertController(title: "Ooups", message: "L'utilisateur \(UdacityClient.sharedInstance().firstName!) \(UdacityClient.sharedInstance().lastName!) a déjà posté sa localisation", preferredStyle: UIAlertControllerStyle.Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alert) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alertController.addAction(cancelAction)
                
                let overwrite = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
                    self.performSegueWithIdentifier("presentEnterLocationWithOverwrite", sender: self)
                })
                alertController.addAction(overwrite)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            })
            
        } else {
            performSegueWithIdentifier("presentEnterLocation", sender: self)
        }

    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().studentInformation.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Student", forIndexPath: indexPath) as! UITableViewCell
        var student = ParseClient.sharedInstance().studentInformation[indexPath.row]
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel?.text = student.mediaURL

        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        if let url = NSURL(string: tableView.cellForRowAtIndexPath(indexPath)!.detailTextLabel!.text!)! as? NSURL {
            app.openURL(url)
        }
        
    }
    
}