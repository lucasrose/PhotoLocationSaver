//
//  TakePictureViewController.swift
//  photoG
//
//  Created by Lucas Rose on 11/22/16.
//  Copyright © 2016 Lucas Rose. All rights reserved.
//

import UIKit
import AVFoundation

class TakePictureViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    var locationName = ""
    var locationDetails = ""
    var locationCoordinates = ""
    var locationImage = ""
    var locationNotes = ""
    var locationGenre = ""
    var locationRecordingURL = ""
    
    var cameraUseAuthorizedByUser = false

    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // - CAMERA SETUP
        checkAccessHasBeenGranted()
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
            saveImageToDocumentsDirectory(image: image)
        }

        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func saveImageToDocumentsDirectory(image: UIImage?){
        // ** NEED TO save image to documents directory
        let directoryPath = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask)
        
        let locationNameWithoutSpaces = locationName.replacingOccurrences(of: " ", with: "_")
        
        if let img = image {
            if let data = UIImageJPEGRepresentation(img, 0.8) {
                let filename = directoryPath[0].appendingPathComponent("\\Images\\\(locationNameWithoutSpaces).png")
                try? data.write(to: filename)
                print(filename)
            }
        }

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
