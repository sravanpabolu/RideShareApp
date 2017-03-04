//
//  RouteListViewController.swift
//  RideShareApp
//
//  Created by Sravan on 24/02/17.
//  
//

import Foundation
import UIKit

class RouteListViewController: BaseViewController {
    
    var strSource: String?
    var strDestination: String?
    var iNumberOfSeats: Int?
    var dtBookingDate: Date?
    let mapDataManager = MapDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapDataManager.getRoutesBetween(source: "Siruseri, Tamil Nadu", destination: "Velachery, Chennai, Tamil Nadu", waypoints: nil, travelMode: nil) { (status, success, routes) in
            print("test %d",routes?.count)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
