//
//  LocationViewController.swift
//  photoG
//
//  Created by Lucas Rose on 11/21/16.
//  Copyright © 2016 Lucas Rose. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    var dataObjectPassed = [String]()
    
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var locationImageView: UIImageView!
    
    var coordinates = ""
    var recordingURL = ""
    
    @IBAction func playAudioNotesButtonTapped(_ sender: UIButton) {
    
    }
    
    @IBAction func showOnFlickrButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowSingleLocationFlickr", sender: self)
    }
    
    @IBAction func showOnMapButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowSingleLocationMap", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTitle()
        detailLabel.text = dataObjectPassed[1]
        
        coordinates = dataObjectPassed[2]
        //get image here
        
        let paths = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask)[0]
        
        let image = paths.appendingPathComponent(dataObjectPassed[3])
        
        if (paths.isFileURL){
            locationImageView.image = UIImage(contentsOfFile: image.path)
        }
        
        notesTextView.text = dataObjectPassed[4]
        
        recordingURL = dataObjectPassed[5]
        
        // Do any additional setup after loading the view.
    }
    
    func setTitle() {
        let labelRect = CGRect(x: 0, y: 0, width: 300, height: 42)
        let titleLabel = UILabel(frame: labelRect)
        titleLabel.text = dataObjectPassed[0] // Photo Location Name
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        self.navigationItem.titleView = titleLabel
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
        
        if (segue.identifier == "ShowSingleLocationMap"){
            let singleMapViewController : SingleMapViewController = segue.destination as! SingleMapViewController
            singleMapViewController.locationName = dataObjectPassed[0]
            singleMapViewController.locationDetails = dataObjectPassed[1]
            singleMapViewController.coordinates = coordinates
            
        } else if (segue.identifier == "ShowSingleLocationFlickr") {
            let flickrImageViewController : FlickrImageViewController = segue.destination as! FlickrImageViewController
            flickrImageViewController.locationName = dataObjectPassed[0]
        }
    }
    

}
