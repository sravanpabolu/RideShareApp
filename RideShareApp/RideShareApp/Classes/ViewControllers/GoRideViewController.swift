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
    @IBOutlet weak var btnStartRide: UIButton!
    var locationMarker:GMSMarker = GMSMarker()
    let dbManager = DatabaseManager()

    static var iTmp = 0
    
    var selectedRide: Rides?
    var locChangeTimer = Timer()
    var arrAllCoord: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleSeatChangeNotification), name: NSNotification.Name(rawValue: "SeatChangeNotification"), object: nil)
        self.locationMarker.map = self.mapView
        self.locationMarker.icon = UIImage(named: "car.png")
        self.locationMarker.opacity = 0.75
        btnStartRide.setTitle("Start Ride", for: .normal)

        self.getGoRideDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func startRide(_ sender: Any) {
        
        if (btnStartRide.currentTitle == "Start Ride") {
            btnStartRide.setTitle("End Ride", for: .normal)
            self.arrAllCoord = self.selectedRide?.arrRouteLatLong
            var strTmp = self.arrAllCoord?[MapViewController.iTmp]
            let arrTmp = strTmp?.characters.split{$0 == ","}.map(String.init)
            let coord = CLLocationCoordinate2DMake(Double((arrTmp?[0])!)! ,
                                                   Double((arrTmp?[1])!)!)
            
            self.locationMarker.icon = UIImage(named: "car.png")
            self.locationMarker = GMSMarker(position: coord)
            
            if(GoRideViewController.iTmp == ((self.arrAllCoord?.count)! - 1)) {
                self.locChangeTimer.invalidate()
            }
            else {
                self.locChangeTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector:#selector(self.simulateLocationChange), userInfo: nil, repeats: true)
                
            }
        }
        else {
            btnStartRide.setTitle("Start Ride", for: .normal)

            self.locChangeTimer.invalidate()

        }
        
    }
    
    func getGoRideDetails() {
        let mapManager = MapDataManager()
        
        self.dbManager.getRideData{(ride,success) in
            if(success) {
                self.selectedRide = ride
                if let arrTmp = self.selectedRide?.arrPassengerDestinations {
                    for strTmp in arrTmp{
                        mapManager.geocodeAddress(address: strTmp, withCompletionHandler: { (coord, success) in
                            self.updatePassengerInMap(paxCoord: coord!, paxSrc: strTmp)
                        })
                        
                    }

                }
                self.updateUI()
                self.dbManager.isVehicleOwner{ [unowned self](isVehicleOwner) in
                    if(!isVehicleOwner) {
                        self.btnStartRide.isHidden = true
                        self.dbManager.observeForLocChange(rideId: (self.selectedRide?.strRideId)!, completionHandler: { (loc, success) in
                            if(success) {
                                let arrTmp = loc.characters.split{$0 == ","}.map(String.init)
                                let coord = CLLocationCoordinate2DMake(Double((arrTmp[0]))! ,
                                                                       Double((arrTmp[1]))!)
                                
                                print(self.navigationController?.topViewController)
                                print(self.navigationController?.visibleViewController)

                                if(self.navigationController?.visibleViewController is GoRideViewController)
                                {
                                    CATransaction.begin()
                                    CATransaction.setAnimationDuration(2.0)
                                    self.locationMarker.position = coord ;
                                    self.mapView.camera = GMSCameraPosition.camera(withTarget: coord, zoom: 13.0)
                                    
                                    CATransaction.commit()
                                }
                            }
                        })
                    }
                }
            } else {
                let alertController = UIAlertController(title: "Ride not available", message: "There are no open rides", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(alertController, animated: true, completion: nil)
                
            }
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
    func updatePassengerInMap(paxCoord:CLLocationCoordinate2D, paxSrc:String)
    {
        let passengerDestinationMarker = GMSMarker(position: paxCoord)
        passengerDestinationMarker.map = self.mapView
        passengerDestinationMarker.icon = GMSMarker.markerImage(with: UIColor.green)
        passengerDestinationMarker.title = paxSrc
    }
    func simulateLocationChange()
    {
        MapViewController.iTmp = MapViewController.iTmp + 1
        
        var strTmp = self.arrAllCoord?[MapViewController.iTmp]
        self.dbManager.updateCoordForRide(rideId: (self.selectedRide?.strRideId)!, coord: strTmp!)

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
    
    func handleSeatChangeNotification() {
        self.getGoRideDetails()
        let alertController = UIAlertController(title: "Ride Booking", message: "Your seats are booked", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
}
