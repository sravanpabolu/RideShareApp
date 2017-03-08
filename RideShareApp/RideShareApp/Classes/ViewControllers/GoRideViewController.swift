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
    var locationMarker:GMSMarker = GMSMarker()
    
    static var iTmp = 0
    
    var selectedRide: Rides?
    var locChangeTimer = Timer()
    var arrAllCoord: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        let dbManager = DatabaseManager()
        dbManager.getRideData{(ride,success) in
            if(success) {
                self.selectedRide = ride
                self.updateUI()
            } else {
                let alertController = UIAlertController(title: "Ride not available", message: "There are no open rides", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func startRide(_ sender: Any) {
        
        
        self.arrAllCoord = self.selectedRide?.arrRouteLatLong
        var strTmp = self.arrAllCoord?[MapViewController.iTmp]
        let arrTmp = strTmp?.characters.split{$0 == ","}.map(String.init)
        let coord = CLLocationCoordinate2DMake(Double((arrTmp?[0])!)! ,
                                               Double((arrTmp?[1])!)!)
        self.locationMarker = GMSMarker(position: coord)
        self.locationMarker.map = self.mapView
        self.locationMarker.icon = UIImage(named: "car.png")
        self.locationMarker.opacity = 0.75
        
        if(GoRideViewController.iTmp == ((self.arrAllCoord?.count)! - 1)) {
            self.locChangeTimer.invalidate()
        }
        else {
            self.locChangeTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector:#selector(self.simulateLocationChange), userInfo: nil, repeats: true)
            
        }
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
        
        let arrLatLong = self.selectedRide?.arrRouteLatLong
        let arrTmp = arrLatLong?.map{$0.characters.split{$0 == ","}.map(String.init)}
        let arrCoordTmp = arrTmp.map{$0.map{CLLocationCoordinate2DMake(Double($0[0])!, Double($0[1])!)}}
        
        let routePolyline = GMSPolyline(path: GMSPath())
        routePolyline.map = self.mapView;
        let mutablePath = GMSMutablePath(path: routePolyline.path!)
        for coord in arrCoordTmp! {
            mutablePath.add(coord)
        }
        routePolyline.path = mutablePath
        routePolyline.strokeWidth = 4
        
        //MARK: Polyline to be checked
        //        let path: GMSPath = GMSPath(fromEncodedPath: (self.selectedRide?.strRouteOverllPoints)!)!
        //        let routePolyline = GMSPolyline(path: path)
        //        routePolyline.map = self.mapView
        
    }
    
    func simulateLocationChange()
    {
        MapViewController.iTmp = MapViewController.iTmp + 1
        
        var strTmp = self.arrAllCoord?[MapViewController.iTmp]
        let arrTmp = strTmp?.characters.split{$0 == ","}.map(String.init)
        let coord = CLLocationCoordinate2DMake(Double((arrTmp?[0])!)! ,
                                               Double((arrTmp?[1])!)!)
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        self.locationMarker.position = coord ;
        self.mapView.camera = GMSCameraPosition.camera(withTarget: coord, zoom: 13.0)
        
        CATransaction.commit()
        if(MapViewController.iTmp == ((self.arrAllCoord?.count)! - 1)) {
            self.locChangeTimer.invalidate()
        }
    }
}
