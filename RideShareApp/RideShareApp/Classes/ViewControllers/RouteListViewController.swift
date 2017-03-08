//
//  RouteListViewController.swift
//  RideShareApp
//
//  Created by Sravan on 24/02/17.
//
//

import Foundation
import UIKit

class RouteListViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tblRoutes: UITableView!
    var strSource: String?
    var strDestination: String?
    var iNumberOfSeats: Int?
    var dtBookingDate: Date?
    var isDriver: Bool?
    
    let user = User()
    
    
    let mapDataManager = MapDataManager.sharedMapDataManager
    let dbManager = DatabaseManager()
    
    var arrRoutes: [Routes] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblRoutes.backgroundColor = UIColor.black
        tblRoutes.layer.masksToBounds = true
        tblRoutes.layer.borderColor = UIColor( red: 153/255, green: 153/255, blue:0/255, alpha: 1.0 ).cgColor
        tblRoutes.layer.borderWidth = 2.0
        dbManager.isVehicleOwner{ [unowned self](isVehicleOwner) in
            self.isDriver = isVehicleOwner
            self.getRoutes(isDriver: self.isDriver!)

        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleSeatChangeNotification), name: NSNotification.Name(rawValue: "SeatChangeNotification"), object: nil)
        
        //        isDriver = user.userVehicle.isVehicleOwner
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrRoutes.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(isDriver)! {
            let cellRoute = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as! RouteTableViewCell
            cellRoute.contentView.backgroundColor = UIColor.black
            
            let routeObj = self.arrRoutes[indexPath.row]
            cellRoute.lblRouteName.text = routeObj.strRouteName
            cellRoute.lblDistance.text = routeObj.strRouteDistance
            cellRoute.lblDuration.text = routeObj.strRouteTime
            return cellRoute
        }
        else {
            let cellRide = tableView.dequeueReusableCell(withIdentifier: "RideCell", for: indexPath) as! RideSelectionTableViewCell
            cellRide.contentView.backgroundColor = UIColor.black
            
            let routeObj = self.arrRoutes[indexPath.row]
            cellRide.lblRideDtl.text = routeObj.strRouteSource + "->" + routeObj.strRouteDestination
            
            cellRide.lblRouteName.text = routeObj.strRouteName
            cellRide.lblDriverName.text = routeObj.strUserName! + "-" + routeObj.strUserVehicle! + "-" + String(describing: routeObj.iNumberOfSeats!) + "seats available"
            cellRide.lblTime.text = routeObj.strRouteTime
            return cellRide
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let routeObj = self.arrRoutes[indexPath.row]
        
        if(isDriver)! {
            mapDataManager.selectedRoute = routeObj
            
            let ride = Rides()
            ride.rideSource = self.strSource!
            ride.rideDestination = self.strDestination!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy hh:mm a"
            let strTmp = dateFormatter.string(from: self.dtBookingDate!)
            ride.rideStartTime = dateFormatter.date(from: strTmp)
            ride.rideRouteName = routeObj.strRouteName
            ride.arrRouteLatLong = routeObj.arrRouteLatLong
            ride.arrRoutePoints = routeObj.arrRoutePoints
            ride.strRouteOverllPoints = routeObj.strRouteOverllPoints
            ride.iSeatAvailable = self.iNumberOfSeats!
            dbManager.saveRideData(ride: ride){[unowned self](rideId) in
                self.dbManager.observeForAvailableSeats(rideId: rideId){(passengerDetail,seatCount,success) in
                    if(success) {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SeatChangeNotification"), object: nil)
                        
                    }
                    
                }
                
                let alertController = UIAlertController(title: "Ride Booking", message: "Ride Booking initiated successfully", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            dbManager.savePassengerRideData(strRideId: routeObj.strRideId!, seatRequired: self.iNumberOfSeats!, destination: self.strDestination!){(success) in
                if(success) {
                    let alertController = UIAlertController(title: "Ride Booking", message: "Ride Booking initiated successfully", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Ride Booking", message: "Booking over", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        
    }
    
    func getRoutes(isDriver:Bool) {
        
        if(isDriver) {
            self.mapDataManager.getRoutesBetween(source: strSource, destination: strDestination, waypoints: nil, travelMode: nil) { (status, success, routes) in
                
                self.arrRoutes = routes!
                self.tblRoutes.reloadData()
            }
        }
        else {
            
            mapDataManager.geocodeAddress(address: self.strDestination, withCompletionHandler: { [unowned self](coord, success) in
                if(success) {
                    self.dbManager.getAllRidesWithSource(source: self.strSource!,andTime: self.dtBookingDate!,andDestination: coord) { ride in
                        self.arrRoutes = ride
                        self.tblRoutes.reloadData()
                        
                    }
                }
            })
            
        }
        
    }
    
    func handleSeatChangeNotification() {
        let alertController = UIAlertController(title: "Ride Booking", message: "Your seats are booked", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
