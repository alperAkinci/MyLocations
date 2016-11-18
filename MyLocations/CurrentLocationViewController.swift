//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Alper on 18/11/16.
//  Copyright © 2016 alper. All rights reserved.
//

import UIKit

class CurrentLocationViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var tagButton: UIButton!
    
    @IBOutlet weak var getLocationButton: UIButton!
    
    @IBAction func getLocation(_ sender: UIButton) {
    }
    
    
    
}
