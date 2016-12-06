//
//  MapViewController.swift
//  MyLocations
//
//  Created by Alper on 06/12/16.
//  Copyright © 2016 alper. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var managedObjectContext: NSManagedObjectContext!
    var locations = [Location]()

    @IBAction func showUser() {
        
        //When you press the User button, it zooms in the map to a region that is 1000 by 1000 meters (a little more than half a mile in both directions) around the user’s position.
        let region = MKCoordinateRegionMakeWithDistance(
            mapView.userLocation.coordinate, 1000, 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    
    //show the region that contains all the user’s saved locations. Before you can do that, you first have to fetch those locations from the data store.
    @IBAction func showLocations() {
        
        let theRegion = region(for: locations)
        mapView.setRegion(theRegion, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This fetches the Location objects and shows them on the map when the view loads.
        updateLocations()
        
        if !locations.isEmpty{
            showLocations()
        }
    }
    
    
    
    func updateLocations() {
        
        // Why we remove annotation?
        // The idea is that updateLocations() will be executed every time there is a change in the data store. How you’ll do that is of later concern, but the point is that when this happens the locations array may already exist and may contain Location objects. If so, you first remove the pins for these old objects with removeAnnotations().
        mapView.removeAnnotations(locations)
        
        // you’re not sorting the Location objects. The order of the Location objects in the array doesn’t really matter to the map view, only their latitude and longitude coordinates.
        let entity = Location.entity()
        let fetchRequest = NSFetchRequest<Location>()
        fetchRequest.entity = entity
        
        //You’ve seen how to handle errors with a do-try-catch block. If you’re certain that a particular method call will never fail, you can dispense with the do and catch and just write try! with an exclamation point. As with other things in Swift that have exclamation points, if it turns out that you were wrong, the app will crash without mercy.
        locations = try! managedObjectContext.fetch(fetchRequest)
        mapView.addAnnotations(locations)
        
    }
    
    
    //calculate a region and then tell the map view to zoom to that region.
    func region(for annotations: [MKAnnotation]) -> MKCoordinateRegion {
        let region: MKCoordinateRegion
        
        switch annotations.count {
        
        //There are no annotations. You’ll center the map on the user’s current position.
        case 0:
            region = MKCoordinateRegionMakeWithDistance(
                mapView.userLocation.coordinate, 1000, 1000)
        
        //There is only one annotation. You’ll center the map on that one annotation.
        case 1:
            let annotation = annotations[annotations.count - 1]
            region = MKCoordinateRegionMakeWithDistance(
                annotation.coordinate, 1000, 1000)
        
        //There are two or more annotations. You’ll calculate the extent of their reach and add a little padding. See if you can make sense of those calculations. The max() function looks at two values and returns the larger of the two; min() returns the smaller; abs() always makes a number positive (absolute value).
        default:
            var topLeftCoord = CLLocationCoordinate2D(latitude: -90,
                                                      longitude: 180)
            var bottomRightCoord = CLLocationCoordinate2D(latitude: 90,
                                                          longitude: -180)
            for annotation in annotations {
                topLeftCoord.latitude = max(topLeftCoord.latitude,
                                            annotation.coordinate.latitude)
                topLeftCoord.longitude = min(topLeftCoord.longitude,
                                             annotation.coordinate.longitude)
                bottomRightCoord.latitude = min(bottomRightCoord.latitude,
                                                annotation.coordinate.latitude)
                bottomRightCoord.longitude = max(bottomRightCoord.longitude, annotation.coordinate.longitude)
            }
            
            let center = CLLocationCoordinate2D(
                latitude: topLeftCoord.latitude -
                    (topLeftCoord.latitude - bottomRightCoord.latitude) / 2,
                longitude: topLeftCoord.longitude -
                    (topLeftCoord.longitude - bottomRightCoord.longitude) / 2)
            let extraSpace = 1.1
            
            let span = MKCoordinateSpan(
                latitudeDelta: abs(topLeftCoord.latitude -
                    bottomRightCoord.latitude) * extraSpace,
                longitudeDelta: abs(topLeftCoord.longitude -
                    bottomRightCoord.longitude) * extraSpace)
            
            region = MKCoordinateRegion(center: center, span: span)
        }
        return mapView.regionThatFits(region)
    }

}

extension MapViewController: MKMapViewDelegate {

}
