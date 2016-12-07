//
//  TakePictureViewController.swift
//  photoG
//
//  Created by Lucas Rose on 11/22/16.
//  Copyright © 2016 Lucas Rose. All rights reserved.
//

import UIKit
import AVFoundation

class TakePictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Outlet References
    @IBOutlet var imageView: UIImageView!
    
    // MARK: Global Variables
    var locationName = ""
    var locationDetails = ""
    var locationCoordinates = ""
    var locationImage = ""
    var locationNotes = ""
    var locationGenre = ""
    var locationRecordingURL = ""
    
    var cameraUseAuthorizedByUser = false

    var imagePicker = UIImagePickerController()
    
    // MARK: View Load
    override func viewDidLoad() {
        super.viewDidLoad()

        checkAccessHasBeenGranted()
        
        // Set image picker to be delegate
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.modalPresentationStyle = .fullScreen
        
        present(imagePicker, animated: true, completion: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Verify the user has granted camera access
    func checkAccessHasBeenGranted() {
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {
            
            /* "The response parameter is a block whose sole parameter [named here as permissionGranted]
             indicates whether the user granted or denied permission to record." [Apple]
             */
            permissionGranted in
            if permissionGranted {
                
                self.cameraUseAuthorizedByUser = true
                
            } else {
                self.cameraUseAuthorizedByUser = false
            }
        })
    }
    
    // Sets the image and passes image to be saved to documents directory
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        
        saveImageToDocumentsDirectory(image: image)
        
        // dismisses the UIImagePickerController
        dismiss(animated: true, completion: nil)
    }
    
    // Cancels UIImagePickerController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // dismiss UIImagePickerController after cancel
        dismiss(animated: true, completion: nil)
    }
    
    // Saves image taken to documents directory
    func saveImageToDocumentsDirectory(image: UIImage?){
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
        
        let data = UIImageJPEGRepresentation(image!, 0.8)
        let filename = directoryPath[0].appendingPathComponent("Images/\(locationNameWithoutSpaces).jpg")
        
        do {
            try data?.write(to: filename, options: .atomic)
            
        } catch {
            print("error")
        }
        locationImage = "Images/\(locationNameWithoutSpaces).jpg"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
