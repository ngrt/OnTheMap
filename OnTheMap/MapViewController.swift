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
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func postStudent(sender: AnyObject){
        performSegueWithIdentifier("presentEnterLocation", sender: self)
    }
    
    func reloadData(sender: AnyObject) {
        loadStudentLocations()
    }
    
    
    
    func loadStudentLocations() {

        var annotations = [MKPointAnnotation]()
        
        ParseClient.sharedInstance().getInfo { (result, error) -> Void in
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
