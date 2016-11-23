//
//  AppDelegate.swift
//  photoG
//
//  Created by Lucas Rose on 10/25/16.
//  Copyright © 2016 Lucas Rose. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var cameraUseAuthorizedByUser = false

    // Instance variable to hold the object reference of a Dictionary object, the content of which is modifiable at runtime
    var dict_My_Photo_Locations: NSMutableDictionary = NSMutableDictionary()
    var array_Photo_Genres: NSMutableArray = NSMutableArray()
    
    /*
     ---------------------------
     MARK: - Read the Array and Dictionary
     ---------------------------
     */
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // - READ FROM PLIST FILES IN DOCUMENT DIRECTORY
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        // Add the plist filename to the document directory path to obtain an absolute path to the plist filename
        let plistMyPhotoLocationsFilePathInDocumentDirectory = documentDirectoryPath + "/MyPhotoLocations.plist"
        let plistPhotoGenresFilePathInDocumentDirectory = documentDirectoryPath + "/PhotoGenres.plist"
        
        
        let myPhotoLocationsDictionaryFromFile: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistMyPhotoLocationsFilePathInDocumentDirectory)
        
        let photoGenresArrayFromFile: NSMutableArray? = NSMutableArray(contentsOfFile: plistPhotoGenresFilePathInDocumentDirectory)

        
        // Read the photo locations dictionary and store it
        
        if let myPhotoLocationsFromFileInDocumentDirectory = myPhotoLocationsDictionaryFromFile {
            
            dict_My_Photo_Locations = myPhotoLocationsFromFileInDocumentDirectory
        }
        else {
            //Read it from the main bundle.
            
            // Obtain the file path to the plist file in the mainBundle (project folder)
            let myPhotoLocationsPlistFilePathInMainBundle = Bundle.main.path(forResource: "MyPhotoLocations", ofType: "plist")
            
            // Instantiate an NSMutableDictionary object and initialize it with the contents of the CountryCities.plist file.
            let myPhotoLocationsDictionaryFromFileInMainBundle: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: myPhotoLocationsPlistFilePathInMainBundle!)
            
            // Store the object reference into the instance variable
            dict_My_Photo_Locations = myPhotoLocationsDictionaryFromFileInMainBundle!
        }
        
        //read the photo genres locations array and store it
        
        if let photoGenresFromFileInDocumentDirectory = photoGenresArrayFromFile {
            array_Photo_Genres = photoGenresFromFileInDocumentDirectory
        }
        else{
            //Read it from the main bundle.
            
            // Obtain the file path to the plist file in the mainBundle (project folder)
            let photoGenresPlistFilePathInMainBundle = Bundle.main.path(forResource: "PhotoGenres", ofType: "plist")
            
            // Instantiate an NSMutableDictionary object and initialize it with the contents of the CountryCities.plist file.
            let photoGenresArrayFromFileInMainBundle: NSMutableArray? = NSMutableArray(contentsOfFile: photoGenresPlistFilePathInMainBundle!)
            
            // Store the object reference into the instance variable
            array_Photo_Genres = photoGenresArrayFromFileInMainBundle!
        }
        
        // - CAMERA SETUP
        
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
        
        return true
    }

    /*
     ----------------------------
     MARK: - Write the Dictionaries
     ----------------------------
     */
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        // Define the file path to the CountryCities.plist file in the Document directory
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        // Add the plist filename to the document directory path to obtain an absolute path to the plist filename
        let myPhotoLocationsPlistFilePathInDocumentDirectory = documentDirectoryPath + "/MyPhotoLocations.plist"
        let photoGenresPlistFilePathInDocumentDirectory = documentDirectoryPath + "/PhotoGenres.plist"
        // Write the NSMutableDictionary to the CountryCities.plist file in the Document directory
        dict_My_Photo_Locations.write(toFile: myPhotoLocationsPlistFilePathInDocumentDirectory, atomically: true)
        array_Photo_Genres.write(toFile: photoGenresPlistFilePathInDocumentDirectory, atomically: true)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

