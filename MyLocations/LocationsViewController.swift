//
//  LocationsViewController.swift
//  MyLocations
//
//  Created by Alper on 01/12/16.
//  Copyright © 2016 alper. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class LocationsViewController: UITableViewController {

    var managedObjectContext : NSManagedObjectContext!
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get all Location objects from the data store and sort them by date.
        
        // 1 - The NSFetchRequestis the object that describes which objects you’re going to fetch from the data store. To retrieve an object that you previously saved to the data store, you create a fetch request that describes the search parameters of the object – or multiple objects – that you’re looking for.
        // info : The < > mean that NSFetchRequest is a generic. Recall that arrays are also generics, because to create an array you specify the type of objects that go into the array, either using the shorthand notation [Location], or the longer Array<Location>.To use an NSFetchRequest, you need to tell it what type of objects you’re going to be fetching. Here, you create an NSFetchRequest<Location> so that the result of fetch() is an array of Location objects.
        
        let fetchRequest = NSFetchRequest<Location>()

        // 2 - Here you tell the fetch request you’re looking for Location entities
        let entity = Location.entity()
        fetchRequest.entity = entity
        
        // 3 - The NSSortDescriptor tells the fetch request to sort on the date attribute,in ascending order. In order words, the Location objects that the user added first will be at the top of the list. You can sort on any attribute here (later in this tutorial you’ll sort on the Location’s category as well).
        let sortDescripter = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        
        
        // 4 - Now that you have the fetch request,you can tell the context to execute it.The fetch() method returns an array with the sorted objects, or throws an error in case something went wrong. That’s why this happens inside a do-try-catch block.
        do {
            locations = try managedObjectContext.fetch(fetchRequest)
        } catch {
            fatalCoreDataError(error)
        }
        
    }

    
    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Location Cell", for: indexPath) as! LocationCell
        
        let location = locations[indexPath.row]
        cell.configure(for: location)
        
        return cell
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EditLocation"{
        
            let navigationController = segue.destination as! UINavigationController
            
            let locationDetailVC = navigationController.topViewController as! LocationDetailViewController
            
            locationDetailVC.managedObjectContext = managedObjectContext
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                
                let location = locations[indexPath.row]
                locationDetailVC.locationToEdit = location
                
            }
            
        
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
