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
    var locationName : String!
    var locationDetails : String!
    var locationCoordinates : String!
    var locationImage : String!
    var locationNotes : String!
    var locationGenre : String!
    var locationRecordingURL : String!
    
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
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        // ** NEED TO save image to documents directory
        let image : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
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
