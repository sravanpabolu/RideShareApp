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
    var selectedRide: Rides?
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User.sharedInstance
        let dbManager = DatabaseManager()
        dbManager.getRideData(rideId: "") {(ride) in
            self.selectedRide = ride
            self.updateUI()
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func startRide(_ sender: Any) {
    }
    
    func updateUI()
    {
        self.txtSource.text = self.selectedRide?.rideSource
        self.txtDestination.text = self.selectedRide?.rideDestination
        
        self.mapView.camera = GMSCameraPosition.camera(withTarget: (self.selectedRide?.strSrcCoord)!, zoom: 13.0)
        
        let originMarker = GMSMarker(position: (self.selectedRide?.strSrcCoord)!)
        originMarker.map = self.mapView
        originMarker.icon = GMSMarker.markerImage(with: UIColor.green)
        originMarker.title = self.selectedRide?.rideSource
        
        let destinationMarker = GMSMarker(position: (self.selectedRide?.strDesCoord)!)
        destinationMarker.map = self.mapView
        destinationMarker.icon = GMSMarker.markerImage(with: UIColor.red)
        destinationMarker.title = self.selectedRide?.rideDestination
//        let coordinate = CLLocationCoordinate2D(latitude: self.mapDataManager.fAddressLatitude, longitude: self.mapDataManager.fAddressLongitude)
        
        let path: GMSPath = GMSPath(fromEncodedPath: (self.selectedRide?.strRouteOverllPoints)!)!
        let routePolyline = GMSPolyline(path: path)
        routePolyline.map = self.mapView
        
    }
    
}
