//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Alper on 18/11/16.
//  Copyright © 2016 alper. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController,CLLocationManagerDelegate {
 
//MARK: Globals
    
    var location : CLLocation?
    var locationManager = CLLocationManager()
    var updatingLocation = false
    var lastLocationError : Error?
    
//MARK: Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getLocationButton: UIButton!

//MARK: Actions
    @IBAction func getLocation(_ sender: UIButton) {
        
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .denied || authStatus == .restricted {
            showlocationServicesDisabledAlert()
            /*
            -Important
            The return statement below takes you out of from getLocation(_:_) action method
            */
            return
        }
        
        //.notDetermined means the app has not asked for permission yet
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            startLocationManager()
        }
        updateLabels()
        configureGetButton()
    }
    
//MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
        configureGetButton()
    }
    
    
    
//MARK: - CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("DidFailWithError : \(error)")
        
        if (error as NSError).code == CLError.locationUnknown.rawValue{
            return
        }
        
        lastLocationError = error
        stopLocationManager()
        updateLabels()
        configureGetButton()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations : \(newLocation)")
        
        // 1 If the time at which the given location object was determined is too long ago (5seconds in this case), then this is a so-called cached result.
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        // 2 horizontalAccuracy that is less than 0, in which case these measurements are invalid and you should ignore them.
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        // 3 So if this is the very first location reading (location is nil) or the new location is more accurate than the previous reading, you continue to step 4. Otherwise you ignore this location update.
        // If the first one is true (location is nil), it will ignore the second condition. That’s called short circuiting.
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            
            // 4 It clears out any previous error if there was one and stores the new CLLocation object into the location variable.
            lastLocationError = nil
            location = newLocation
            updateLabels()
            // 5 If the new location’s accuracy is equal to or better than the desired accuracy, you can call it a day and stop asking the location manager for updates.
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("*** We're done!")
                stopLocationManager()
                configureGetButton()
            }
        }
    }
    
    
//MARK: - Convenience Methods 
    
    func showlocationServicesDisabledAlert(){
        
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func updateLabels(){
        
        if let location = location {
            latitudeLabel.text = String(format: "%.8f",location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            messageLabel.text = ""
            tagButton.isHidden = false
            
        }else{
            
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            tagButton.isHidden = true
            
            
            let statusMessage: String
            if let error = lastLocationError as? NSError {
                if error.domain == kCLErrorDomain &&
                    error.code == CLError.denied.rawValue {
                    statusMessage = "Location Services Disabled"
                } else {
                    statusMessage = "Error Getting Location"
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disabled"
            } else if updatingLocation {
                statusMessage = "Searching..."
            } else {
                statusMessage = "Tap 'Get My Location' to Start"
            }
            
            messageLabel.text = statusMessage
            
        }
    
    }
    
    func startLocationManager(){
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    
    
    func stopLocationManager(){
        
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    
    func configureGetButton() {
        if updatingLocation {
            getLocationButton.setTitle("Stop", for: .normal)
        } else {
            getLocationButton.setTitle("Get My Location", for: .normal)
        }
    }
    
}
