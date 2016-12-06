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

    @IBOutlet var writtenNotesTextView: UITextView!
    
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var recordButton: UIButton!
    var locationName = ""
    var locationDetails = ""
    var locationGenre = ""
    var locationCoordinates = ""
    var locationRecordingURL = ""
    
    var audioSession: AVAudioSession!
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        writtenNotesTextView.text = ""
        
        stopButton.isEnabled = false
        stopButton.isHidden = true
        playButton.isEnabled = false
        
        let directoryPath = FileManager.default.urls(for: .documentDirectory,
                                    in: .userDomainMask)

        let locationNameWithoutSpaces = locationName.replacingOccurrences(of: " ", with: "_")
        
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
        
        locationRecordingURL = soundURL.absoluteString

        // Do any additional setup after loading the view.
    }
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
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        recordButton.isHidden = true
        recordButton.isEnabled = false
        
        playButton.isEnabled = false

        stopButton.isEnabled = true
        stopButton.isHidden = false
        
        if recorder?.isRecording == false {
            recorder?.record()
        }
    }

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
            
            // - ***MAKE SURE TO PASS AUDIO FILE NAME FOR NOTES
            takePictureViewController.locationName = locationName
            takePictureViewController.locationDetails = locationDetails
            takePictureViewController.locationNotes = writtenNotesTextView.text
            takePictureViewController.locationGenre = locationGenre
            takePictureViewController.locationCoordinates = locationCoordinates
            takePictureViewController.locationRecordingURL = locationRecordingURL

        }
    }
 

}
