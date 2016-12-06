//
//  Location+CoreDataClass.swift
//  MyLocations
//
//  Created by Alper on 28/11/16.
//  Copyright © 2016 alper. All rights reserved.
//

import Foundation
import CoreData
import MapKit

@objc(Location)



public class Location: NSManagedObject , MKAnnotation {
    /* MKAnnotation
     
     The MKAnnotation protocol simply lets you pretend that Location is an annotation that can be placed on a map view. You can use this trick with any object you want; as long as the object implements the MKAnnotation protocol it can be shown on a map.
     Protocols let objects wear different hats.
     
    */
    
    
    
    /*
    ***INFO***
    **********
     - These variables below are read-only computed properties. That means they don’t actually store a value into a memory location. Whenever you access the coordinate, title, or subtitle variables, they perform the logic from their code blocks. That’s why they are computed properties: they compute something.
    
     - These properties are read-only because they only return a value – you can’t give them a new value using the assignment operator.
    *********
    *********
    */
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    public var subtitle: String? {
        return category
    }
    
    public var title: String? {
        if locationDescription.isEmpty {
            return "(No Description)"
        } else {
            return locationDescription
        }
    }
    //Alternative method (instead of using computed properties)
    //    func title() -> String? {
    //        if locationDescription.isEmpty {
    //            return "(No Description)"
    //        } else {
    //            return locationDescription
    //        }
    //    }
    
    
    
}
