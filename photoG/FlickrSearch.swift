//
//  FlickrSearch.swift
//  photoG
//
//  Created by Lucas Rose on 12/6/16.
//  Copyright © 2016 Lucas Rose. All rights reserved.
//

//API KEY: 24dd1b16e9c82b9ed5acb99d86d8e8a8

//API SECRET: 743b56908ef6ad95


import Foundation
import UIKit


class FlickrSearch {
    
    private let API_KEY = "24dd1b16e9c82b9ed5acb99d86d8e8a8"
    
    var results = [String]()
    
    init() {
        
    }
    
    
    // String format from Flickr API Documentation
    func URLForFlickrSearch(query: String) -> String {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(API_KEY)&text=\(encodedQuery!)&per_page=15&format=json&nojsoncallback=1"
    }
    
    
    // String format from Flickr API Documentation
    func URLForFlickrPhoto(photo: FlickrPhoto) -> String {
    
        return "https://farm\(photo.farmID!).staticflickr.com/\(photo.serverID!)/\(photo.photoID!)_\(photo.secret!)_m.jpg"
    }
    
    func searchFlickrWithQuery(searchString: String, completion: @escaping (_ searchString: String?, _ photos:NSMutableArray?, _ error: NSError?)->() ){
        let searchURLString = URLForFlickrSearch(query: searchString)
        
        DispatchQueue.global(qos: .background).async {
            //do stuff
            let url = URL.init(string: searchURLString)
            
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
                let data: Data! = (searchResult.data(using: String.Encoding.utf8, allowLossyConversion: false) as Data!)
                
                
                print(data)
                //USE SwiftyJSON Library for cleaner JSON Parsing
                let json = JSON(data: data)

                let status = json["stat"].string
                
                if status == "fail" {
                    let error: NSError? = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: json["message"].object])
                    
                    completion(searchString, nil, error)
                } else {
                    //let photosJSON = json["photos"].dictionary
                    
                    let allPhotosDict = json ["photos"].dictionary
                    let results = allPhotosDict?["photo"]?.arrayObject
                    
                    
                    //let results = photosJSON?["photo"]?.array
                    //let results : NSArray = json["photos"]["photo"].object as! NSArray
                    
                    let flickrPhotos = NSMutableArray()
                    
                    for photo in results! {
                        let currentPhoto = photo as! NSDictionary
                        
                        var flickrPhoto = FlickrPhoto()
                        flickrPhoto.farmID = currentPhoto["farm"] as! Int
                        flickrPhoto.serverID = currentPhoto["server"] as! String
                        flickrPhoto.photoID = currentPhoto["id"] as! String
                        flickrPhoto.secret = currentPhoto["secret"] as! String
                        
                        
                        let searchURL = self.URLForFlickrPhoto(photo: flickrPhoto)
                        let imageURL = URL.init(string: searchURL)
                        var imageData: NSData?
                        
                        do {
                            imageData = try NSData(contentsOf: imageURL!)
                        } catch error! as NSError {
                            print(error?.localizedDescription)
                        } catch {
                            print("Other error has occurred processing image data")
                        }
                        
                        if imageData != nil {
                            let image = UIImage(data: imageData as! Data)
                            flickrPhoto.image = image
                            flickrPhotos.add(flickrPhoto)
                        }
                        
                        
                    }
                    completion(searchString, flickrPhotos, nil)
                    
                }
                
                
                
                
                                
            }
        }
    }
    
    
    
    class FlickrPhoto : NSObject {
        var photoID : String!
        var serverID : String!
        var farmID : Int!
        var secret : String!
        
        var image : UIImage!
        
        override init(){    // override NSObject parent class
            
            
        }
        
        
        
        
        
    }
    
    
}
