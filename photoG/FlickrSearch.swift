//
//  FlickrSearch.swift
//  photoG
//
//  Created by Lucas Rose on 12/6/16.
//  Copyright © 2016 Lucas Rose. All rights reserved.
//
//
//API KEY: 24dd1b16e9c82b9ed5acb99d86d8e8a8

import Foundation
import UIKit

class FlickrSearch {
    // Needed for Flickr API Calls
    private let API_KEY = "24dd1b16e9c82b9ed5acb99d86d8e8a8"
    
    // MARK: Global Variables
    var results = [String]()
    
    // MARK: Object Constructor
    init() {}
    
    // MARK: Flickr API Call Methods
    
    // Formats URL API request string according to Flickr API Documentation
    func URLForFlickrSearch(query: String) -> String {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(API_KEY)&text=\(encodedQuery!)&per_page=15&format=json&nojsoncallback=1"
    }
    
    // Formats Image API request string according to Flickr API Documentation
    func URLForFlickrPhoto(photo: FlickrPhoto) -> String {
        return "https://farm\(photo.farmID!).staticflickr.com/\(photo.serverID!)/\(photo.photoID!)_\(photo.secret!)_m.jpg"
    }
    
    // Seearches Flickr with given input string and returns array of related photos upon completion
    func searchFlickrWithQuery(searchString: String, completion: @escaping (_ searchString: String?, _ photos:NSMutableArray?, _ error: NSError?)->() ){
        let searchURLString = URLForFlickrSearch(query: searchString)
        
        // Execute task on background thread as to not freeze the Main UI thread
        DispatchQueue.global(qos: .background).async {
            //do stuff
            let url = URL.init(string: searchURLString)
            
            // Create Search From URL
            var error : NSError?
            var searchResult: String!
            
            do {
                searchResult = try String.init(contentsOf: url!, encoding: String.Encoding.utf8)
                
            } catch error! as NSError {
                print(error?.localizedDescription)
            } catch {
                print("Another error has occurred.")
            }
            
            if error != nil {
                completion(searchURLString, nil, error)
            } else {
                // save data from search
                let data: Data! = (searchResult.data(using: String.Encoding.utf8, allowLossyConversion: false) as Data!)
                
                // Create JSON object from data - Uses SwiftyJSON Open Source Library
                let json = JSON(data: data)

                let status = json["stat"].string
                
                if status == "fail" {
                    let error: NSError? = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: json["message"].object])
                    
                    completion(searchString, nil, error)
                } else {
                    // Get photos from JSON
                    let allPhotosDict = json ["photos"].dictionary
                    let results = allPhotosDict?["photo"]?.arrayObject
                    
                    let flickrPhotos = NSMutableArray()
                    
                    // Iterate through results and create FlickrPhoto objects, populate array
                    for photo in results! {
                        let currentPhoto = photo as! NSDictionary
                        
                        var flickrPhoto = FlickrPhoto()
                        flickrPhoto.farmID = currentPhoto["farm"] as! Int
                        flickrPhoto.serverID = currentPhoto["server"] as! String
                        flickrPhoto.photoID = currentPhoto["id"] as! String
                        flickrPhoto.secret = currentPhoto["secret"] as! String
                        
                        // Create Search URL and Image URL for given photo
                        let searchURL = self.URLForFlickrPhoto(photo: flickrPhoto)
                        let imageURL = URL.init(string: searchURL)
                        var imageData: NSData?
                        
                        // Try to store image data from the image URL
                        do {
                            imageData = try NSData(contentsOf: imageURL!)
                        } catch error! as NSError {
                            print(error?.localizedDescription)
                        } catch {
                            print("Other error has occurred processing image data")
                        }
                        
                        // Add the image if there is an image found for that item
                        if imageData != nil {
                            let image = UIImage(data: imageData as! Data)
                            flickrPhoto.image = image
                            flickrPhotos.add(flickrPhoto)
                        }
                    }
                    // Escapes without error on completion and method terminates
                    completion(searchString, flickrPhotos, nil)
                }
            }
        }
    }
    
    // MARK: FlickrPhoto Subclass
    class FlickrPhoto : NSObject {
        
        // MARK: Global Variables
        var photoID : String!
        var serverID : String!
        var farmID : Int!
        var secret : String!
        var image : UIImage!
        
        // MARK: Object Consructor (Override NSObject)
        override init(){
            
        }
    }
}
