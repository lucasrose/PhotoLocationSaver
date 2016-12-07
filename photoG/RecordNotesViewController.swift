//
//  RecordNotesViewController.swift
//  photoG
//
//  Created by Lucas Rose on 11/22/16.
//  Copyright © 2016 Lucas Rose. All rights reserved.
//

import UIKit
import AVFoundation

class RecordNotesViewController: UIViewController, UITextViewDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    // MARK: Outlet References
    @IBOutlet var writtenNotesTextView: UITextView!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var recordButton: UIButton!
    
    // MARK: Global Variables
    var locationName = ""
    var locationDetails = ""
    var locationGenre = ""
    var locationCoordinates = ""
    var locationRecordingURL = ""
    
    var audioSession: AVAudioSession!
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    
    // MARK: View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        writtenNotesTextView.text = ""
        
        stopButton.isEnabled = false
        stopButton.isHidden = true
        playButton.isEnabled = false
        
    }
    
    // MARK: Outlet Functions
    
    // Stops playing the recorded notes
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        recordButton.isHidden = false
        recordButton.isEnabled = true
        
        playButton.isEnabled = true

        stopButton.isEnabled = false
        stopButton.isHidden = true
        
        if recorder?.isRecording == true {
            recorder?.stop()
        } else {
            recorder?.stop()
        }
    }
    
    // Starts playing the recorded notes
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if recorder?.isRecording == false {
            do {
                try player = AVAudioPlayer(contentsOf:
                    (recorder?.url)!)
                player!.delegate = self
                player!.prepareToPlay()
                player!.play()
            } catch let error as NSError {
                print("audioPlayer error: \(error.localizedDescription)")
            }
        }
    }
    
    // Sets up the recording, file creation, and allows playback
    func setUpRecordingAndPlayback(){
        let directoryPath = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask)
        
        var uniqueFilename = ""
        
        if (locationDetails.characters.count > 10){
            let index = locationDetails.index(locationDetails.startIndex, offsetBy: 9)
            uniqueFilename = locationName.appending(locationDetails.substring(to: index))
        } else{
            uniqueFilename = locationName.appending(locationDetails)
        }
        
        let locationNameWithoutSpaces = uniqueFilename.replacingOccurrences(of: " ", with: "_")
        
        let soundURL = directoryPath[0].appendingPathComponent("Recordings/\(locationNameWithoutSpaces).caf")
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try recorder = AVAudioRecorder(url: soundURL,
                                           settings: recordSettings as [String : AnyObject])
            recorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        locationRecordingURL = "Recordings/\(locationNameWithoutSpaces).caf"
    }
    
    // Starts a new audio recording
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        setUpRecordingAndPlayback()
        
        recordButton.isHidden = true
        recordButton.isEnabled = false
        
        playButton.isEnabled = false

        stopButton.isEnabled = true
        stopButton.isHidden = false
        
        if recorder?.isRecording == false {
            recorder?.record()
        }
    }

    // Show the Take Picture View Controller
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "TakePicture", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     ---------------------------------
     MARK: - Keyboard Handling Methods
     ---------------------------------
     */
    
    // This method is invoked when the user taps the Done key on the keyboard
    @IBAction func keyboardDone(_ sender: UITextView) {
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "TakePicture") {
            let takePictureViewController: TakePictureViewController = segue.destination as! TakePictureViewController
            
            // Pass data to Take Picture View Controller
            takePictureViewController.locationName = locationName
            takePictureViewController.locationDetails = locationDetails
            takePictureViewController.locationNotes = writtenNotesTextView.text
            takePictureViewController.locationGenre = locationGenre
            takePictureViewController.locationCoordinates = locationCoordinates
            takePictureViewController.locationRecordingURL = locationRecordingURL

        }
    }
}
