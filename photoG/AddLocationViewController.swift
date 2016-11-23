//
//  AddLocationViewController.swift
//  photoG
//
//  Created by Lucas Rose on 11/21/16.
//  Copyright © 2016 Lucas Rose. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var locationDetailsTextField: UITextField!
    @IBOutlet var locationGenrePickerView: UIPickerView!
    @IBOutlet var locationNameTextField: UITextField!
    
    var photoGenres = [String]()
    var coordinates : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoGenres = applicationDelegate.array_Photo_Genres as! [String]
        photoGenres.sort { $0 < $1 }
        // Do any additional setup after loading the view.
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "RecordNotes", sender: self)
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
            
            // Under the Delegation Design Pattern, set the addCityViewController's delegate to be self
            
            getLocationCoordinates()
            
            let selectedRowNumber = locationGenrePickerView.selectedRow(inComponent: 0)
            
            let photoGenre = photoGenres[selectedRowNumber]
            
            recordNotesViewController.locationName = locationNameTextField.text
            recordNotesViewController.locationDetails = locationDetailsTextField.text
            recordNotesViewController.locationGenre = photoGenre
            recordNotesViewController.locationCoordinates = coordinates
        }
    }
    
    func getLocationCoordinates() {
        //mapkit stuff here
    }
    
}
