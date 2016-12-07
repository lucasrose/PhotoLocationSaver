//
//  LocationViewController.swift
//  photoG
//
//  Created by Lucas Rose on 11/21/16.
//  Copyright © 2016 Lucas Rose. All rights reserved.
//

import UIKit
import AVFoundation

class LocationViewController: UIViewController, AVAudioPlayerDelegate {

    var dataObjectPassed = [String]()
    
    @IBOutlet var playNotesButton: UIButton!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var locationImageView: UIImageView!
    
    var coordinates = ""
    var recordingURL : URL!
    
    var player: AVAudioPlayer!
    var audioSession: AVAudioSession!

    @IBAction func playAudioNotesButtonTapped(_ sender: UIButton) {
            do {
                
                try player = AVAudioPlayer(contentsOf:
                    (recordingURL))
                player!.delegate = self
                player!.prepareToPlay()
                player!.play()
            } catch let error as NSError {
                print("audioPlayer error: \(error.localizedDescription)")
            }
        
    }
    
    @IBAction func showOnFlickrButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowSingleLocationFlickr", sender: self)
    }
    
    @IBAction func showOnMapButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowSingleLocationMap", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playNotesButton.isEnabled = false
        playNotesButton.isHidden = true
        
        setTitle()
        detailLabel.text = dataObjectPassed[1]
        
        coordinates = dataObjectPassed[2]
        notesTextView.text = dataObjectPassed[4]

        // Display Image
        
        let paths = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask)[0]
        
        let image = paths.appendingPathComponent(dataObjectPassed[3])
        
        if (image.isFileURL && dataObjectPassed[3] != ""){
            locationImageView.image = UIImage(contentsOfFile: image.path)
        }
        
        // Setup Audio Note Playback
        
        audioSession = AVAudioSession.sharedInstance()
        
        let audioNotes = paths.appendingPathComponent(dataObjectPassed[5])
        
        if (audioNotes.isFileURL && dataObjectPassed[5] != ""){
            playNotesButton.isHidden = false
            playNotesButton.isEnabled = true
            recordingURL = audioNotes
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
            } catch let error as NSError {
                print("audioSession error: \(error.localizedDescription)")
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func setTitle() {
        let labelRect = CGRect(x: 0, y: 0, width: 300, height: 42)
        let titleLabel = UILabel(frame: labelRect)
        titleLabel.text = dataObjectPassed[0] // Photo Location Name
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont(name: "Avenir Next", size: 16)
        titleLabel.textAlignment = .center
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
