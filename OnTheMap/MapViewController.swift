//
//  MapViewController.swift
//  
//
//  Created by Nawfal on 29/07/2015.
//
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var students: [ParseStudentInformation]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var refreshData : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: Selector("reloadData:"))
        var postData : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("postStudent:"))
        

        var buttons : NSArray = [postData, refreshData]
        
        self.navigationItem.rightBarButtonItems = buttons as! [UIBarButtonItem]
        
        loadStudentLocations()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        loadStudentLocations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func postStudent(sender: AnyObject){
        if ParseClient.sharedInstance().studentExist(String(UdacityClient.sharedInstance().userID!)) == true {
            println("existe")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let alertController = UIAlertController(title: "Ooups", message: "L'utilisateur \(UdacityClient.sharedInstance().firstName!) \(UdacityClient.sharedInstance().lastName!) a déjà posté sa localisation", preferredStyle: UIAlertControllerStyle.Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alert) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alertController.addAction(cancelAction)
                
                let overwrite = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.Default, handler: { (alert) -> Void in
                    self.performSegueWithIdentifier("presentEnterLocation", sender: self)
                })
                alertController.addAction(overwrite)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            })

        } else {
            performSegueWithIdentifier("presentEnterLocation", sender: self)
        }
    }
    
    func reloadData(sender: AnyObject) {
        loadStudentLocations()
    }
    
    @IBAction func logout(sender: AnyObject) {
        UdacityClient.sharedInstance().logOut(self)
    }
    
    
    func loadStudentLocations() {

        var annotations = [MKPointAnnotation]()
        
        ParseClient.sharedInstance().getInfo { (result, error) -> Void in
            
            self.students = result!
            
            for studentInformation in result! {
                
                // Notice that the float values are being used to create CLLocationDegree values.
                // This is a version of the Double type.
                let lat = CLLocationDegrees(studentInformation.latitude as Float)
                let long = CLLocationDegrees(studentInformation.longitude as Float)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = studentInformation.firstName as String
                let last = studentInformation.lastName as String
                let mediaURL = studentInformation.mediaURL as String
                
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                var annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
            }
            
            // When the array is complete, we add the annotations to the map.
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.mapView.addAnnotations(annotations)
            })
        }
        
        println(students)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
