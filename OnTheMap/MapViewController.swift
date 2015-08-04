//
//  MapViewController.swift
//  
//
//  Created by Nawfal on 29/07/2015.
//
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var refreshData : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: Selector("reloadData:"))
        var postData : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("postStudent:"))
        var buttons : NSArray = [postData, refreshData]
        self.navigationItem.rightBarButtonItems = buttons as! [UIBarButtonItem]
        
        loadStudentLocations()
        ParseClient.sharedInstance().studentExist(String(UdacityClient.sharedInstance().userID!))

    }
    
    override func viewWillAppear(animated: Bool) {
        loadStudentLocations()
    }
    
    func postStudent(sender: AnyObject){

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
    
    func reloadData(sender: AnyObject) {
        loadStudentLocations()
    }
    
    @IBAction func logout(sender: AnyObject) {
        UdacityClient.sharedInstance().logOut(self)
    }
    
    
    func loadStudentLocations() {
        
        var annotations = [MKPointAnnotation]()
        
        for studentInformation in ParseClient.sharedInstance().studentInformation {
            
            let lat = CLLocationDegrees(studentInformation.latitude as Float)
            let long = CLLocationDegrees(studentInformation.longitude as Float)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
            let first = studentInformation.firstName as String
            let last = studentInformation.lastName as String
            let mediaURL = studentInformation.mediaURL as String
            
            var annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.mapView.addAnnotations(annotations)
            })
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
    
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation.subtitle!)!)
        }
    }

}
    





