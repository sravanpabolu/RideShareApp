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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
