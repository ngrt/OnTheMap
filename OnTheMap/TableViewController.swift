//
//  TableViewController.swift
//  
//
//  Created by Nawfal on 30/07/2015.
//
//

import UIKit

class TableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    var students: [ParseStudentInformation]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStudentLocations()

    }
    
    @IBAction func reloadData(sender: AnyObject) {
        
        loadStudentLocations()
        
    }
    
    func loadStudentLocations() {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            ParseClient.sharedInstance().getInfo { (result, error) -> Void in
                if error != nil {
                    println("Error in downloading the list of students (item tab bar)")
                } else {
    
                    self.students = result!
    
    
                }
            }
        })

    }
    
    func postingLocation() {
        
    }
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.students!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Student", forIndexPath: indexPath) as! UITableViewCell
        var student = students![indexPath.row]
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel?.text = student.mediaURL

        return cell
    }
    
}
