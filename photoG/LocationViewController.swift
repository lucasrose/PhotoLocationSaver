//
//  LocationViewController.swift
//  photoG
//
//  Created by Lucas Rose on 11/21/16.
//  Copyright © 2016 Lucas Rose. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    var dataObjectPassed = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle()
        
        // Do any additional setup after loading the view.
    }
    
    func setTitle() {
        let labelRect = CGRect(x: 0, y: 0, width: 300, height: 42)
        let titleLabel = UILabel(frame: labelRect)
        titleLabel.text = dataObjectPassed[0] // Photo Location Name
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        self.navigationItem.titleView = titleLabel
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