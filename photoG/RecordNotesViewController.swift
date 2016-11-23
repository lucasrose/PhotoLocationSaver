//
//  RecordNotesViewController.swift
//  photoG
//
//  Created by Lucas Rose on 11/22/16.
//  Copyright © 2016 Lucas Rose. All rights reserved.
//

import UIKit

class RecordNotesViewController: UIViewController {

    @IBOutlet var writtenNotesTextView: UITextView!
    
    var locationName : String!
    var locationDetails : String!
    var locationGenre : String!
    var locationCoordinates : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func recordButtonTapped(_ sender: UIButton) {
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "TakePicture", sender: self)
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
        if (segue.identifier == "TakePicture") {
            let takePictureViewController: TakePictureViewController = segue.destination as! TakePictureViewController
            
            // - ***MAKE SURE TO PASS AUDIO FILE NAME FOR NOTES
            takePictureViewController.locationName = locationName
            takePictureViewController.locationDetails = locationDetails
            takePictureViewController.locationNotes = writtenNotesTextView.text
            takePictureViewController.locationGenre = locationGenre
            takePictureViewController.locationCoordinates = locationCoordinates

        }
    }
 

}
