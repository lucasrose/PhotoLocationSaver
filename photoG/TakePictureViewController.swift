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

    @IBOutlet var imageView: UIImageView!
    var locationName = ""
    var locationDetails = ""
    var locationCoordinates = ""
    var locationImage = ""
    var locationNotes = ""
    var locationGenre = ""
    var locationRecordingURL = ""
    
    var cameraUseAuthorizedByUser = false

    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // - CAMERA SETUP
        checkAccessHasBeenGranted()
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        
        saveImageToDocumentsDirectory(image: image)
        
        //save image to doc dir.
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //add code here to handle not saving an image
        dismiss(animated: true, completion: nil)
    }
    
    func saveImageToDocumentsDirectory(image: UIImage?){
        // ** NEED TO save image to documents directory
        let directoryPath = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask)
        
        let locationNameWithoutSpaces = locationName.replacingOccurrences(of: " ", with: "_")
        
        let data = UIImageJPEGRepresentation(image!, 0.8)
        let filename = directoryPath[0].appendingPathComponent("Images/\(locationNameWithoutSpaces).jpg")
        
        do {
            try data?.write(to: filename, options: .atomic)
            
        } catch {
            print("error")
        }
        locationImage = "Images/\(locationNameWithoutSpaces).jpg"

        //http://stackoverflow.com/questions/35685685/how-to-save-an-image-picked-from-a-uiimagepickercontroller-in-swift
        //http://stackoverflow.com/questions/33916652/how-to-save-image-or-video-from-uipickerviewcontroller-to-document-directory

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
