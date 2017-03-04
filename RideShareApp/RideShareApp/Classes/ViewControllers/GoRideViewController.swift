//
//  GoRideViewController.swift
//  RideShareApp
//
//  Created by Sravan on 23/02/17.
//  
//

import Foundation
import UIKit
import GoogleMaps

class GoRideViewController: BaseViewController {
    
    @IBOutlet weak var txtSource: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var txtDestination: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func startRide(_ sender: Any) {
    }
    
}
