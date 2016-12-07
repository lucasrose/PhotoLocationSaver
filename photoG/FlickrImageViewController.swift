//
//  FlickrImageViewController.swift
//  photoG
//
//  Created by Lucas Rose on 11/21/16.
//  Copyright © 2016 Lucas Rose. All rights reserved.
//


//API KEY: 24dd1b16e9c82b9ed5acb99d86d8e8a8

//API SECRET: 743b56908ef6ad95

import UIKit

class FlickrImageViewController: UIViewController {

    var locationName : String!
    var setOfPhotos = NSMutableArray()
    var imageNumber = 0
    
    @IBOutlet var nextButton: UIButton!
    
    @IBOutlet var previousButton: UIButton!
    
    @IBOutlet var flickrImageView: UIImageView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previousButton.isEnabled = false
        
        getPhotosFromFlickr()
        
        // Do any additional setup after loading the view.
    }
    
    func getPhotosFromFlickr(){
        previousButton.isEnabled = false
        nextButton.isEnabled = false

        let flickrSearch = FlickrSearch()
        flickrSearch.searchFlickrWithQuery(searchString: locationName, completion: {(searchString: String?, flickrPhotos: NSMutableArray?, error: NSError?) -> () in
            
            if error != nil {
                
            } else {
                let flickrPhoto: FlickrSearch.FlickrPhoto = flickrPhotos?.object(at: 0) as! FlickrSearch.FlickrPhoto
                let image = flickrPhoto.image
                
                DispatchQueue.main.async {
                    self.flickrImageView.image = image
                    self.nextButton.isEnabled = true
                }
                
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
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
