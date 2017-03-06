//
//  MapViewController.swift
//  RideShareApp
//
//  Created by Kanya Rajan on 2/18/17.
//  
//

import UIKit
import CoreLocation
import GoogleMaps
import QuartzCore
class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    var didFindMyLocation = false
    let mapDataManager = MapDataManager()
    var arrAllCoord: Array<CLLocationCoordinate2D> = []
    static var iTmp = 0
    var locationMarker:GMSMarker = GMSMarker()
    var helloWorldTimer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        mapDataManager.geocodeAddress(address: "Mettukuppam, Chennai, Tamil Nadu") { (status, success) in
            if(success)
            {
//                let coordinate = CLLocationCoordinate2D(latitude: self.mapDataManager.fAddressLatitude, longitude: self.mapDataManager.fAddressLongitude)
//                let locationMarker = GMSMarker(position: coordinate)
//                self.mapView.camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 14.0)
//                locationMarker.map = self.mapView
//                locationMarker.title = self.mapDataManager.strFormattedAddress
//                locationMarker.opacity = 0.75
            }
        }
//        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)

        self.mapDataManager.getDirections(origin: "EB2 South Wing, Siruseri, Tamil Nadu 603103, India", destination: "EB4, Siruseri, Tamil Nadu 603103, India", waypoints: nil, travelMode: nil) { (status, success) in
            if(success)
            {
                self.mapView.camera = GMSCameraPosition.camera(withTarget: self.mapDataManager.originCoordinate, zoom: 13.0)
                
                let originMarker = GMSMarker(position: self.mapDataManager.originCoordinate)
                originMarker.map = self.mapView
                originMarker.icon = GMSMarker.markerImage(with: UIColor.green)
                originMarker.title = self.mapDataManager.strOriginAddress
                
                let destinationMarker = GMSMarker(position: self.mapDataManager.destinationCoordinate)
                destinationMarker.map = self.mapView
                destinationMarker.icon = GMSMarker.markerImage(with: UIColor.red)
                destinationMarker.title = self.mapDataManager.strDestinationAddress
                let coordinate = CLLocationCoordinate2D(latitude: self.mapDataManager.fAddressLatitude, longitude: self.mapDataManager.fAddressLongitude)

                for dictTmp in self.mapDataManager.arrOverviewPolylines
                {

                    let route = dictTmp?["points"] as! String
                    let path: GMSPath = GMSPath(fromEncodedPath: route)!
                    let routePolyline = GMSPolyline(path: path)
                    routePolyline.map = self.mapView
                    let bIsAvailable:Bool = GMSGeometryContainsLocation(coordinate, path, true)
                    print(bIsAvailable)
//                    NSLog("%i", bIsAvailable)
                }
            }
//            self.arrAllCoord = self.mapDataManager.getAllCoordinatesAlongRoute(route: self.mapDataManager.arrSelectedRoute.first!!)
//            
//            self.locationMarker = GMSMarker(position: self.arrAllCoord[MapViewController.iTmp] )
//            self.locationMarker.map = self.mapView
//            self.locationMarker.icon = GMSMarker.markerImage(with: UIColor.black)
//            self.locationMarker.opacity = 0.75
            if(MapViewController.iTmp == (self.arrAllCoord.count - 1)) {
                self.helloWorldTimer.invalidate()
            }
            else {
                self.helloWorldTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector:#selector(self.simulateLocationChange), userInfo: nil, repeats: true)

            }
        }

        
    }
    
    
    func simulateLocationChange()
    {
        MapViewController.iTmp = MapViewController.iTmp + 1
        let coord:CLLocationCoordinate2D = arrAllCoord[MapViewController.iTmp]
        CATransaction.begin()
        CATransaction.setAnimationDuration(10.0)
        locationMarker.position = coord ;
        CATransaction.commit()
        if(MapViewController.iTmp == (self.arrAllCoord.count - 1)) {
            self.helloWorldTimer.invalidate()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                      of object: Any?,
                      change: [NSKeyValueChangeKey : Any]?,
                      context: UnsafeMutableRawPointer?){
        
    if !didFindMyLocation {
            let myLocation: CLLocation = change![NSKeyValueChangeKey.newKey] as! CLLocation
            mapView.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 50.0)
            mapView.settings.myLocationButton = true
        }
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

extension MapViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedWhenInUse){
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
//        }
//
//    }
}
