//
//  InformationPostingViewController.swift
//  
//
//  Created by Nawfal on 30/07/2015.
//
//

import UIKit
import MapKit


class InformationPostingViewController: UIViewController, UITextFieldDelegate {

    

    @IBOutlet weak var finBtn: UIButton!
    @IBOutlet weak var whereStydyingLabel: UILabel!
    @IBOutlet weak var locationTexfField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var firstPage = true
    
    var coords: CLLocationCoordinate2D?
    
    @IBAction func findOnTheMap(sender: AnyObject) {
        
        if firstPage {
            convertStringToGeoloc()
            whereStydyingLabel.text = "Enter a link to share here"
            finBtn.setTitle("Submit", forState: UIControlState.Normal)
            firstPage = false
            mapView.hidden = false
            websiteTextField.hidden = false
            locationTexfField.hidden = true
        
        } else {
            //l'envoi du studentInfo vers Parse
            websiteTextField.hidden = true
            locationTexfField.hidden = false
            firstPage = true
            ParseClient.sharedInstance().sendInfo(String(UdacityClient.sharedInstance().userID!), firstName: UdacityClient.sharedInstance().firstName!, lastName: UdacityClient.sharedInstance().lastName!, mapString: locationTexfField.text!, mediaURL: websiteTextField.text!, latitude: Float(coords!.latitude), longitude: Float(coords!.longitude), hostViewController : self)
            

        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            //lancer la func reloadData.
        })
    }
    
    //lost my source...
    func convertStringToGeoloc() {
        let geoCoder = CLGeocoder()
        
        let addressString = locationTexfField.text!
        
        geoCoder.geocodeAddressString(addressString, completionHandler:
            {(placemarks: [AnyObject]!, error: NSError!) in
                
                if error != nil {
                    println("Geocode failed with error: \(error.localizedDescription)")
                } else if placemarks.count > 0 {
                    let placemark = placemarks[0] as! CLPlacemark
                    let location = placemark.location
                    self.coords = location.coordinate
                    
                    var annotation = MKPointAnnotation()
                    annotation.coordinate = self.coords!
//                    annotations.append(annotation)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.mapView.addAnnotation(annotation)
                        self.zoom(self.coords!)
                    })
                    
                    
                }
        })

    }
    
    //http://www.reddit.com/r/swift/comments/2acs9h/how_to_zoom_right_in_using_swift_with_mkmapview/
    func zoom(mapCoord : CLLocationCoordinate2D) {
        var mapCamera = MKMapCamera(lookingAtCenterCoordinate: mapCoord, fromEyeCoordinate: mapCoord, eyeAltitude: 1000)
        mapView.setCamera(mapCamera, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationTexfField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        mapView.hidden = true
        websiteTextField.hidden = true
        
    }


    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        findOnTheMap(textField)
        return true
    }
    

}
