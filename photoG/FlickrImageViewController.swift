//
//  FlickrImageViewController.swift
//  photoG
//
//  Created by Lucas Rose on 11/21/16.
//  Copyright © 2016 Lucas Rose. All rights reserved.
//

import UIKit

class FlickrImageViewController: UIViewController {
    // MARK: Global Variables
    var locationName : String!
    var setOfPhotos = NSMutableArray()
    var imageNumber = 0
    
    // MARK: Outlet Variables
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var previousButton: UIButton!
    @IBOutlet var flickrImageView: UIImageView!
    
    // MARK: Outlet Functions
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        imageNumber += 1
        enableDisableButtons()
        
        if (imageNumber < setOfPhotos.count){
            let flickrPhoto: FlickrSearch.FlickrPhoto = setOfPhotos.object(at: imageNumber) as! FlickrSearch.FlickrPhoto
            self.flickrImageView.image = flickrPhoto.image
        }
    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        imageNumber -= 1
        enableDisableButtons()
        let flickrPhoto: FlickrSearch.FlickrPhoto = setOfPhotos.object(at: imageNumber) as! FlickrSearch.FlickrPhoto
        self.flickrImageView.image = flickrPhoto.image
    }
    
    // Disables buttons when no more photos left before or after the current one
    func enableDisableButtons(){
        if imageNumber > 0 {
            previousButton.isEnabled = true
        } else {
            previousButton.isEnabled = false
        }
        
        if imageNumber < setOfPhotos.count - 1 {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
    
    // MARK: View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previousButton.isEnabled = false
        
        getPhotosFromFlickr()
        
        // Do any additional setup after loading the view.
    }
    
    // Fetches photos from Flickr Asynchronously and updates the image shown and the photo array
    func getPhotosFromFlickr(){
        previousButton.isEnabled = false
        nextButton.isEnabled = false

        // Create Flickr Search
        let flickrSearch = FlickrSearch()
        flickrSearch.searchFlickrWithQuery(searchString: locationName, completion: {(searchString: String?, flickrPhotos: NSMutableArray?, error: NSError?) -> () in
            
            if error != nil {
                
            } else {
                let flickrPhoto: FlickrSearch.FlickrPhoto = flickrPhotos?.object(at: 0) as! FlickrSearch.FlickrPhoto
                let image = flickrPhoto.image
                
                // Update UI on Main Thread
                DispatchQueue.main.async {
                    
                    if image != nil {
                        self.flickrImageView.image = image
                        self.nextButton.isEnabled = true
                    } else {
                        self.showError()
                    }

                }
                
                // Add photos to array
                for photo in flickrPhotos! {
                    self.setOfPhotos.add(photo)
                    
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Displays an error if no relevant photos from Flickr were found
    func showError(){
        let alertController = UIAlertController(title: "No Photos Found",
                                                message: "Sorry, no photos from Flickr matched your description.",
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller by calling the presentViewController method
        present(alertController, animated: true, completion: nil)
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
