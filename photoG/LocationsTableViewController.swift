//
//  LocationsTableViewController.swift
//  photoG
//
//  Created by Lucas Rose on 11/21/16.
//  Copyright © 2016 Lucas Rose. All rights reserved.
//

import UIKit

class LocationsTableViewController: UITableViewController {

    // Use application delegate to access user data
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    // MARK: Outlet References
    @IBOutlet var photoLocationsTableView: UITableView!
    
    // MARK: Local Variables
    var myPhotoGenres = [String]()
    var dataObjectToPass = [String]()
    
    //MARK: View Overload Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(LocationsTableViewController.addLocation(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        myPhotoGenres = applicationDelegate.dict_My_Photo_Locations.allKeys as! [String]
        myPhotoGenres.sort { $0 < $1 }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - TableView Data Source Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return applicationDelegate.dict_My_Photo_Locations.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let photoGenre = myPhotoGenres[section]
        let photoLocations: AnyObject? = applicationDelegate.dict_My_Photo_Locations[photoGenre] as AnyObject
        
        return photoLocations!.count
    }

    /*
     -----------------------
     MARK: - Add Location Method
     -----------------------
     */
    
    // The addLocation method is invoked when the user taps the Add button created in viewDidLoad() above.
    func addLocation(_ sender: AnyObject) {
        performSegue(withIdentifier: "AddLocation", sender: self)
    }
    
    //-----------------------------
    // Set Title for Section Header
    //-----------------------------
    
    // Set the table view section header to be the photo genre name
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return myPhotoGenres[section]
    }
    
    //-------------------------------------
    // Prepare and Return a Table View Cell
    //-------------------------------------
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)

        let sectionNumber = (indexPath as NSIndexPath).section
        let rowNumber = (indexPath as NSIndexPath).row
        
        // Obtain the name of the photo genre
        let givenPhotoGenre = myPhotoGenres[sectionNumber]

        // Obtain the list of photo locations in given photo genre
        let photoLocations: AnyObject? = applicationDelegate.dict_My_Photo_Locations[givenPhotoGenre] as AnyObject
        
        let location = photoLocations?["\(rowNumber + 1)"] as! [String]
        
        let locationName = location[0]
        let locationDescription = location[1]
        
        // Configure the cell...
        cell.textLabel!.text = locationName
        cell.detailTextLabel!.text = locationDescription

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Obtain the name of the genre of the photo to be deleted
            let genreOfPhotoLocationToDelete = myPhotoGenres[(indexPath as NSIndexPath).section]
            
            // Obtain the list of photo locations in the genre as NSMutableDictionary
            let photoLocationsInGenre: NSMutableDictionary = applicationDelegate.dict_My_Photo_Locations[genreOfPhotoLocationToDelete] as! NSMutableDictionary
            
            let photoLocationNumberToRemove = indexPath.row + 1
            
            if (photoLocationNumberToRemove == photoLocationsInGenre.count){ //last photo location -> good
                deleteRecordingAndImage(photoLocationsInGenre: photoLocationsInGenre)

                photoLocationsInGenre.removeObject(forKey: "\(photoLocationNumberToRemove)")
            }
            else{                                           //reorder keys then remove last
                var key = photoLocationNumberToRemove
                
                while(key != photoLocationsInGenre.count){
                    let newPhotoLocation = photoLocationsInGenre.value(forKey: "\(key + 1)")
                    
                    photoLocationsInGenre.setValue(newPhotoLocation, forKey: "\(key)")
                    
                    key += 1;
                }
                
                deleteRecordingAndImage(photoLocationsInGenre: photoLocationsInGenre)
                photoLocationsInGenre.removeObject(forKey: "\(photoLocationsInGenre.count)")
            }

            if photoLocationsInGenre.count == 0 {
                applicationDelegate.dict_My_Photo_Locations.removeObject(forKey: genreOfPhotoLocationToDelete)
                
                // Since the dictionary has been changed, obtain the photo genre names again
                myPhotoGenres = applicationDelegate.dict_My_Photo_Locations.allKeys as! [String]
                
                // Sort the genre names within itself in alphabetical order
                myPhotoGenres.sort { $0 < $1 }
            }
            else {
                applicationDelegate.dict_My_Photo_Locations.setValue(photoLocationsInGenre, forKey: genreOfPhotoLocationToDelete)
            }
            
            photoLocationsTableView.reloadData()
            
            // Alert the map to remove the new location and resize
            NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
        }
    }
    
    // This method will search for an image and audio recording for the photo location about to be deleted.
    // it will then be deleted from the user document directory if it existed
    func deleteRecordingAndImage(photoLocationsInGenre: NSMutableDictionary){
        let deletedPhotoLocation = photoLocationsInGenre.value(forKey: "\(photoLocationsInGenre.count)") as! [String]
        
        let imagePath = deletedPhotoLocation[3]
        let recordingPath = deletedPhotoLocation[5]
        
        let directoryPath = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask)
        
        let photoFilename = directoryPath[0].appendingPathComponent(imagePath)
        let recordingFilename = directoryPath[0].appendingPathComponent(recordingPath)
        
        // Check to make sure the paths are files and not empty before trying to delete
        
        if (photoFilename.isFileURL && imagePath != ""){
            do {
                try FileManager.default.removeItem(at: photoFilename)
                print("Deleted photo.")
            } catch{
                print("Error deleting photo.")
            }
        }
        
        if (recordingFilename.isFileURL && recordingPath != ""){
            do {
                try FileManager.default.removeItem(at: recordingFilename)
                print("Deleted recording.")
            } catch {
                print("Error deleting recording.")
            }
        }

    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let genreOfPhotoLocationToDelete = myPhotoGenres[(fromIndexPath as NSIndexPath).section]
        
        var photoLocationsInGenre: NSMutableDictionary = applicationDelegate.dict_My_Photo_Locations[genreOfPhotoLocationToDelete] as! NSMutableDictionary
        
        // Row number to move FROM
        let rowNumberFrom   = (fromIndexPath as NSIndexPath).row
        
        // Row number to move TO
        let rowNumberTo     = (to as NSIndexPath).row
        
        photoLocationsInGenre = photoLocationsReorderedInGenre(photoLocationsInGenre: photoLocationsInGenre, from: rowNumberFrom, to: rowNumberTo)

        // Update the dictionary
        applicationDelegate.dict_My_Photo_Locations.setValue(photoLocationsInGenre, forKey: genreOfPhotoLocationToDelete)
    }
    
    //---------------------
    // Reordered photo locations method
    //---------------------
    
    func photoLocationsReorderedInGenre(photoLocationsInGenre: NSMutableDictionary, from: Int, to: Int) -> NSMutableDictionary{
        var tempArray: NSMutableArray = []
        
        var items = 0
        
        while (items != (photoLocationsInGenre.count)){   //copy items into ns array
            let element = items + 1
            let movie = photoLocationsInGenre.value(forKey: "\(element)")
            tempArray.add(movie!)
            
            items += 1
        }
        
        let itemFrom = tempArray[from]
        
        if from > to {
            tempArray.insert(itemFrom, at: to)
            tempArray.removeObject(at: from + 1)
            
        }
        else if (from < to){
            tempArray.insert(itemFrom, at: to + 1)
            tempArray.removeObject(at: from)
        }
        
        var count = 0
        
        while (count < photoLocationsInGenre.count){
            let movie = tempArray[count]
            
            photoLocationsInGenre.setValue(movie, forKey: "\(count + 1)")
            count += 1
        }
        
        return photoLocationsInGenre
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    /*
     ----------------------------------
     MARK: - Table View Delegate Method
     ----------------------------------
     */
    
    // This method is invoked when the user taps a table view row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sectionNumber = (indexPath as NSIndexPath).section
        let rowNumber = (indexPath as NSIndexPath).row
        
        // Obtain the name of the photo genre
        let givenPhotoGenre = myPhotoGenres[sectionNumber]
        
        // Obtain the list of photo locations in given photo genre
        let photoLocations: AnyObject? = applicationDelegate.dict_My_Photo_Locations[givenPhotoGenre] as AnyObject
        
        let location = photoLocations?["\(rowNumber + 1)"] as! [String]
        
        // Prepare the data object to pass to the downstream view controller
        dataObjectToPass = location
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "ShowLocationCell", sender: self)
    }
    
    // This method is invoked when the user taps a table view row's detail disclosure
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let sectionNumber = (indexPath as NSIndexPath).section
        let rowNumber = (indexPath as NSIndexPath).row
        
        // Obtain the name of the photo genre
        let givenPhotoGenre = myPhotoGenres[sectionNumber]
        
        // Obtain the list of photo locations in given photo genre
        let photoLocations: AnyObject? = applicationDelegate.dict_My_Photo_Locations[givenPhotoGenre] as AnyObject
        
        let location = photoLocations?["\(rowNumber + 1)"] as! [String]
        
        // Prepare the data object to pass to the downstream view controller
        dataObjectToPass = location
        
        performSegue(withIdentifier: "ShowDetailFlickr", sender: self)
    }
    
    // This method is invoked when the user attempts to move a row
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        let fromPhotoLocationGenre = myPhotoGenres[(sourceIndexPath as NSIndexPath).section]
        let toPhotoLocationGenre = myPhotoGenres[(proposedDestinationIndexPath as NSIndexPath).section]
        
        if fromPhotoLocationGenre != toPhotoLocationGenre {
            let alertController = UIAlertController(title: "Move Not Allowed!",
                                                    message: "You cannot change the photo genre/category.",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            // Present the alert controller by calling the presentViewController method
            present(alertController, animated: true, completion: nil)
            
            return sourceIndexPath
        }
        else {
            return proposedDestinationIndexPath  // approved
        }
    }
    
    /*
     ----------------------------------------------
     MARK: - Unwind Segue Method
     ----------------------------------------------
     */
    @IBAction func unwindToMyLocationsTableViewController (segue : UIStoryboardSegue) {
        
        if segue.identifier == "AddPhotoLocation-Save" {
            
            // Obtain the object reference of the source view controller
            let controller: TakePictureViewController = segue.source as! TakePictureViewController
            
            let locationName = controller.locationName
            let locationDetails = controller.locationDetails
            let locationCoordinates = controller.locationCoordinates
            let locationImage = controller.locationImage
            let locationNotes = controller.locationNotes
            let locationGenre = controller.locationGenre
            let locationRecordingURL = controller.locationRecordingURL
            //
            let dataObject = [locationName, locationDetails, locationCoordinates, locationImage, locationNotes, locationRecordingURL]
                        
            if let photosInGenre = applicationDelegate.dict_My_Photo_Locations[locationGenre] {
                let photoLocationsInGenre = photosInGenre as! NSMutableDictionary
                let count = photoLocationsInGenre.count
                photoLocationsInGenre.setValue(dataObject, forKey: "\(count + 1)")
                
                applicationDelegate.dict_My_Photo_Locations.setValue(photoLocationsInGenre, forKey: locationGenre)
                
            } else{
                var newDictionary = NSMutableDictionary()
                newDictionary.setValue(dataObject, forKey: "\(1)")
                applicationDelegate.dict_My_Photo_Locations.setValue(newDictionary, forKey: locationGenre)
            }
            
            myPhotoGenres = applicationDelegate.dict_My_Photo_Locations.allKeys as! [String]
            myPhotoGenres.sort { $0 < $1 }
            
            
            tableView.reloadData()
            
            // Alert the map to update after adding a new photo location
            NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowLocationCell" {
            
            // Obtain the object reference of the destination view controller
            let locationViewController: LocationViewController = segue.destination as! LocationViewController
            
            locationViewController.dataObjectPassed = dataObjectToPass
        } else if segue.identifier == "ShowDetailFlickr" {
            let flickrImageViewController: FlickrImageViewController = segue.destination as! FlickrImageViewController
            flickrImageViewController.locationName = dataObjectToPass[0]
        }
    }
}
