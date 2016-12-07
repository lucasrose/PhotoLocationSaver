//
//  MapViewController.swift
//  photoG
//
//  Created by Lucas Rose on 11/21/16.
//  Copyright © 2016 Lucas Rose. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    // MARK: Outlet References
    @IBOutlet var mapView: MKMapView!
    
    // MARK: Application Delegate
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: Global Variables
    var photoLocationNames = [String]()
    var photoLocationCoordinates = [String]()
    
    // MARK: View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Observer to update map after adding or deleting location
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMap(_:)), name: Notification.Name("reload"), object: nil)
        
        // Set map view delegate with controller
        self.mapView.delegate = self
        
        // Set map compass and scale
        mapView.showsCompass = true
        mapView.showsScale = true
        
        getLocations()
        addLocationsToMap()
    }
    
    // Update coordinates and locations for map
    func getLocations(){
        photoLocationNames.removeAll()
        photoLocationCoordinates.removeAll()
        let genres = applicationDelegate.array_Photo_Genres
        
        for genre in genres {
            print(genre)
            if let currentGenreLocations = applicationDelegate.dict_My_Photo_Locations[genre] as? NSDictionary{
                var ct = 1
                while(ct <= currentGenreLocations.count) {
                    let current = currentGenreLocations.value(forKey: "\(ct)") as! [String]
                    
                    photoLocationNames.append(current[0])
                    photoLocationCoordinates.append(current[2])
                    ct += 1
                }
            }
        }
    }
    
    // Add all new locations to the map
    func addLocationsToMap(){
        //get all locations from delegate
        let totalLocations = photoLocationNames.count
        var i = 0
        
        
        while (i < totalLocations) {
            let name = photoLocationNames[i]
            let coordinate = photoLocationCoordinates[i]
            let coordinateArr = coordinate.components(separatedBy: ",")
            
            let x = Double(coordinateArr[0])
            let y = Double(coordinateArr[1])
            let currentLocation = CLLocationCoordinate2DMake(x!, y!)
            
            // Drop a pin
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = currentLocation
            dropPin.title = name
            mapView.addAnnotation(dropPin)
            
            i += 1
        }
        mapView.showAnnotations(self.mapView.annotations, animated: true)
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
    
    // Executes when reload notification is fired and updates the map
    func reloadMap(_ notification: Notification) {
        let annotations = self.mapView.annotations
        mapView.removeAnnotations(annotations)
        
        getLocations()
        addLocationsToMap()
    }
}
