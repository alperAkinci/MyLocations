//
//  LocationDetailViewController.swift
//  MyLocations
//
//  Created by Alper on 25/11/16.
//  Copyright © 2016 alper. All rights reserved.
//

import UIKit
import CoreLocation

//DateFormatter is a relatively expensive object to create. In other words, it takes quite long to initialize this object. If you do that many times over then it may slow down your app (and drain the phone’s battery faster).
//It is better to create DateFormatter just once and then re-use that same object over and over. The trick is that you won’t create the DateFormatter object until the app actually needs it. This principle is called "lazy loading" and it’s a very important pattern for iOS apps. The work that you don’t do won’t cost any battery power.
//In addition, you’ll only ever create one instance of DateFormatter. The next time you need to use DateFormatter you won’t make a new instance but re-use the existing one.
//To pull this off you’ll use a private global constant. That’s a constant that lives outside of the LocationDetailViewController class (global) but it is only visible inside the LocationDetailsViewController.swift file (private).It means that this constant is private so it cannot be used outside of this Swift file.
//Inside the closure is the code that creates and initializes the new DateFormatter object, and then returns it. This returned value is what gets put into dateFormatter. The knack to making this work is the () at the end. Closures are like functions, and to perform the code inside the closure you call it just like you’d call a function.

//Note: If you leave out the (), Swift thinks you’re assigning the closure itself to dateFormatter – in other words, dateFormatter will contain a block of code, not an actual DateFormatter object. That’s not what you want.
//Instead you want to assign the result of that closure to dateFormatter. To make that happen, you use the () to perform or evaluate the closure – this runs the code inside the closure and returns the DateFormatter object.
//In Swift, globals are always created in a lazy fashion, which means the code that creates and sets up this DateFormatter object isn’t performed until the very first time the dateFormatter global is used in the app.
private let dateFormatter : DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
    
}()

class LocationDetailViewController: UITableViewController {

    
    //MARK: - Globals
    
    var coordinate = CLLocationCoordinate2D(latitude: 0,longitude: 0)
    var placemark : CLPlacemark?
    
    
    
    //MARK: - Outlets
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    //MARK: - Actions
    @IBAction func done() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.text = " "
        categoryLabel.text = " "
        latitudeLabel.text = String(format: "%.8f",coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        
        if let placemark = placemark{
            addressLabel.text = string(from: placemark)
        }else{
            addressLabel.text = "No Address Found"
        }
        
        dateLabel.text = format(date: Date())
    
    }
    
    //MARK: - Convenience Methods
    
    func string(from placemark: CLPlacemark) -> String {
        var text = ""
        if let s = placemark.subThoroughfare {
            text += s + " " }
        if let s = placemark.thoroughfare {
            text += s + ", "
        }
        if let s = placemark.locality {
            text += s + ", "
        }
        if let s = placemark.administrativeArea {
            text += s + " " }
        if let s = placemark.postalCode {
            text += s + ", "
        }
        if let s = placemark.country {
            text += s }
        return text }

    func format(date : Date) -> String{
        return dateFormatter.string(from: date)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
