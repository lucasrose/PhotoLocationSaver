//
//  SingleMapViewController.swift
//  photoG
//
//  Created by Lucas Rose on 12/5/16.
//  Copyright © 2016 Lucas Rose. All rights reserved.
//

import UIKit
import MapKit

class SingleMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var singleLocationMapView: MKMapView!
    
    var coordinates : String!
    var locationName : String!
    var locationDetails : String!
    override func viewDidLoad() {
        super.viewDidLoad()

        let coordinateArr = coordinates.components(separatedBy: ",")
        
        //wrap in try catch here
        let x = Double(coordinateArr[0])
        let y = Double(coordinateArr[1])
        
        let currentLocation = CLLocationCoordinate2DMake(x!, y!)
        // Drop a pin
        
        let dropPin = MKPointAnnotation()
        
        dropPin.coordinate = currentLocation
        dropPin.title = locationName
        dropPin.subtitle = locationDetails
        
        singleLocationMapView.showsCompass = true
        singleLocationMapView.showsScale = true
        
        singleLocationMapView.addAnnotation(dropPin)
        
        singleLocationMapView.selectAnnotation(dropPin, animated: true)

        let region = getMapRegion(location: currentLocation)
        singleLocationMapView.setRegion(region, animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMapRegion(location: CLLocationCoordinate2D) -> MKCoordinateRegion {
        let latLong = CLLocationDistance.init(8046.72)  //5 mile radius
        
        return MKCoordinateRegionMakeWithDistance(location, latLong, latLong)
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
