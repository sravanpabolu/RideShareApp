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
    let mapDataManager = MapDataManager.sharedMapDataManager
    var arrRoutes: [Routes] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblRoutes.backgroundColor = UIColor.black
        tblRoutes.layer.masksToBounds = true
        tblRoutes.layer.borderColor = UIColor( red: 153/255, green: 153/255, blue:0/255, alpha: 1.0 ).cgColor
        tblRoutes.layer.borderWidth = 2.0
        getRoutes()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrRoutes.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellRoute = tableView.dequeueReusableCell(withIdentifier: "RouteCell", for: indexPath) as! RouteTableViewCell
        cellRoute.contentView.backgroundColor = UIColor.black
        
        let routeObj = self.arrRoutes[indexPath.row]
        cellRoute.lblRouteName.text = routeObj.strRouteName
        cellRoute.lblDistance.text = routeObj.strRouteDistance
        cellRoute.lblDuration.text = routeObj.strRouteTime
        return cellRoute
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let routeObj = self.arrRoutes[indexPath.row]
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
        let dbManager = DatabaseManager()
        dbManager.saveRideData(ride: ride)
        
        let alertController = UIAlertController(title: "Ride Booking", message: "Ride Booking initiated successfully", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)

    }
    
    func getRoutes() {
        
        self.mapDataManager.getRoutesBetween(source: strSource, destination: strDestination, waypoints: nil, travelMode: nil) { (status, success, routes) in
            
            self.arrRoutes = routes!
            self.tblRoutes.reloadData()
        }
        
    }
}
