//
//  AddLocationViewController.swift
//  photoG
//
//  Created by Lucas Rose on 11/21/16.
//  Copyright © 2016 Lucas Rose. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddLocationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, CLLocationManagerDelegate {
    // MARK: Application Delegate
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: Outlet References
    @IBOutlet var locationDetailsTextField: UITextField!
    @IBOutlet var locationGenrePickerView: UIPickerView!
    @IBOutlet var locationNameTextField: UITextField!
    
    // MARK: Gloabl Variables
    var photoGenres = [String]()
    var coordinates : String!
    
    var locationManager : CLLocationManager!
    
    // MARK: View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoGenres = applicationDelegate.array_Photo_Genres as! [String]
        photoGenres.sort { $0 < $1 }
        
        // Show Middle Item in Picker
        let numberOfRowToShow = Int(photoGenres.count / 2)
        locationGenrePickerView.selectRow(numberOfRowToShow, inComponent: 0, animated: false)
        
        getCurrentLocation()
    }

    // MARK: Outlet Function
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        if (locationNameTextField.text == "" || locationDetailsTextField.text == ""){
            /*
             Create a UIAlertController object; dress it up with title, message, and preferred style;
             and store its object reference into local constant alertController
             */
            let alertController = UIAlertController(title: "Error!",
                                                    message: "Please enter a location name and details.",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            // Present the alert controller by calling the presentViewController method
            present(alertController, animated: true, completion: nil)
        }
        else{
            //ADD CHECK TO MAKE SURE LOCATION HAS BEEN RECORDED BEFORE PERFORMING SEGUE!
            performSegue(withIdentifier: "RecordNotes", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "RecordNotes" {
            
            // Obtain the object reference of the destination view controller
            let recordNotesViewController: RecordNotesViewController = segue.destination as! RecordNotesViewController
            
            let selectedRowNumber = locationGenrePickerView.selectedRow(inComponent: 0)
            
            let photoGenre = photoGenres[selectedRowNumber]
            
            recordNotesViewController.locationName = locationNameTextField.text!
            recordNotesViewController.locationDetails = locationDetailsTextField.text!
            recordNotesViewController.locationGenre = photoGenre
            recordNotesViewController.locationCoordinates = coordinates
        }
    }
    
    // Retrieves current location after requesting authorization from user
    func getCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /*
     -----------------------------------------------
     MARK: - UIPickerViewDataSource Protocol Methods
     -----------------------------------------------
     */
    func numberOfComponents(in locationGenrePickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ locationGenrePickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return photoGenres.count
    }
    
    // Sets the PickerView Design/Fonts
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = photoGenres[row]
        pickerLabel.font = UIFont(name: "Avenir Next", size: 16)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    /*
     --------------------------------------------
     MARK: - UIPickerViewDelegate Protocol Method
     --------------------------------------------
     */
    func pickerView(_ locationGenrePickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return photoGenres[row]
    }
    
    /*
     ---------------------------------
     MARK: - Keyboard Handling Methods
     ---------------------------------
     */
    
    // This method is invoked when the user taps the Done key on the keyboard
    @IBAction func keyboardDone(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    /*
     ------------------------------
     MARK: - User Tapped Background
     ------------------------------
     */
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
    
    // Stops updating the location and sets coordinates after grabbing a valid location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        manager.stopUpdatingLocation()
        
        let latitude = manager.location?.coordinate.latitude
        let longitude = manager.location?.coordinate.longitude
        
        coordinates = "\(latitude!),\(longitude!)"
    }
    
    // Retrieves error information from location manager.. required for CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){}
}
