//
//  MapDataManager.swift
//  RideShareApp
//
//  Created by Kanya Rajan on 2/20/17.
//
//

import UIKit
import CoreLocation

class MapDataManager: NSObject {
    
    var dictCoordResults: Dictionary<String, AnyObject>!
    var strFormattedAddress: String!
    
    var fAddressLongitude: Double!
    var fAddressLatitude: Double!
    
    var arrSelectedRoute: Array<Dictionary<String, AnyObject>?>!
    var arrOverviewPolylines: Array<Dictionary<String, AnyObject>?> = []
    
    var dictSelectedRoute: Dictionary<String, AnyObject>!
    var dictOverviewPolyline: Dictionary<String, AnyObject>!
    
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    
    var strOriginAddress: String!
    var strDestinationAddress: String!
    
    static let sharedMapDataManager = MapDataManager()
    var selectedRoute: Routes?
    
    func geocodeAddress(address: String!, withCompletionHandler completionHandler:@escaping ((_ status:String,_ success: Bool) -> Void)){
        if let strAddress = address {
            var strRequest = "https://maps.googleapis.com/maps/api/geocode/json?address=" + strAddress
            strRequest = strRequest.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let urlRequest = URL(string: strRequest)
            DispatchQueue.main.async(execute: {
                let dataResult = NSData(contentsOf: urlRequest!)
                do {
                    let dictGeoCodingResult: Dictionary<String,Any> = try JSONSerialization.jsonObject(with: dataResult as! Data, options: .mutableContainers) as! Dictionary<String,Any>
                    let status = dictGeoCodingResult["status"] as! String
                    if status == "OK" {
                        let dictAllResults = dictGeoCodingResult["results"] as! Array<Dictionary<String, AnyObject>>
                        self.dictCoordResults = dictAllResults[0]
                        self.strFormattedAddress = self.dictCoordResults["formatted_address"] as! String
                        let geometry = self.dictCoordResults["geometry"] as! Dictionary<String, AnyObject>
                        self.fAddressLongitude = ((geometry["location"] as! Dictionary<String, AnyObject>)["lng"] as! NSNumber).doubleValue
                        self.fAddressLatitude = ((geometry["location"] as! Dictionary<String, AnyObject>)["lat"] as! NSNumber).doubleValue
                        completionHandler(status, true)
                    }
                    else {
                        completionHandler(status, false)
                    }
                }catch {
                    
                }
            })
        }
    }
    
    
    func getDirections(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: @escaping ((String, Bool) -> Void)) {
        if let originLocation = origin {
            if let destinationLocation = destination {
                
                var strRequest = "https://maps.googleapis.com/maps/api/directions/json?" + "origin=" + originLocation + "&destination=" + destinationLocation + "&alternatives=true"
                strRequest = strRequest.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let urlDirectionsRequest = URL(string: strRequest)
                
                DispatchQueue.main.async(execute: {
                    let dataDirectionsResult = NSData(contentsOf: urlDirectionsRequest!)
                    
                    do {
                        
                        let dictDirectionResult: Dictionary<String,Any> = try JSONSerialization.jsonObject(with: dataDirectionsResult as! Data, options: .mutableContainers) as! Dictionary<String,Any>
                        let status = dictDirectionResult["status"] as! String
                        
                        if status == "OK" {
                            
                            self.arrSelectedRoute = dictDirectionResult["routes"] as! Array<Dictionary<String, AnyObject>>
                            
                            var legs: Array<Dictionary<String, AnyObject>> = []
                            for dicTmp in self.arrSelectedRoute
                            {
                                self.dictOverviewPolyline = dicTmp?["overview_polyline"] as! Dictionary<String, AnyObject>
                                self.arrOverviewPolylines.append(self.dictOverviewPolyline)
                                legs = dicTmp?["legs"] as! Array<Dictionary<String, AnyObject>>
                                
                            }
                            
                            let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, AnyObject>
                            self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                            
                            let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, AnyObject>
                            self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                            
                            self.strOriginAddress = legs[0]["start_address"] as! String
                            self.strDestinationAddress = legs[legs.count - 1]["end_address"] as! String
                            
                            //                            self.calculateTotalDistanceAndDuration()
                            
                            completionHandler(status, true)
                        }
                        else {
                            completionHandler(status, false)
                        }
                    }catch{
                        
                    }
                    
                })
            }
            else {
                completionHandler("Destination is nil.", false)
            }
        }
        else {
            completionHandler("Origin is nil", false)
        }
    }
    func getAllCoordinatesAndPointsAlongRoute(route: [String : AnyObject]) -> ([String], [String])
    {
        let arrLegs = route["legs"] as! Array<Dictionary<String, AnyObject>>
        var arrCoordinates:[String] = []
        var arrPoints:[String] = []

        for dictLegTmp in arrLegs {
            let arrSteps = dictLegTmp["steps"] as! Array<Dictionary<String, AnyObject>>
            for dictStepTmp in arrSteps {
                let startLocationDictionary = dictStepTmp["start_location"] as! Dictionary<String, AnyObject>
                let endLocationDictionary = dictStepTmp["end_location"] as! Dictionary<String, AnyObject>
                
                let originCoordinate = String(format:"%f,%f", startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                let destinationCoordinate = String(format:"%f,%f", endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                
                let dictTmpStepPolyline = dictStepTmp["polyline"] as! [String:String]
                let strRoutePoint = dictTmpStepPolyline["points"]
                
                arrCoordinates.append(originCoordinate)
                arrCoordinates.append(destinationCoordinate)
                
                arrPoints.append(strRoutePoint!)
            }
            
        }
        return (arrCoordinates,arrPoints)
        
    }
    
    func getRoutesBetween(source: String!, destination: String!, waypoints: [String]!, travelMode: AnyObject!, completionHandler: @escaping ((String, Bool, [Routes]?) -> Void)) {
        
        guard let strOrigin = source, let strDestination = destination else {
            
            completionHandler("Origin/Destination is nil.", false, nil)
            return
            
        }
        
        var strRequest = "https://maps.googleapis.com/maps/api/directions/json?" + "origin=" + strOrigin + "&destination=" + strDestination + "&alternatives=true"
        strRequest = strRequest.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlDirectionsRequest = URL(string: strRequest)
        
        DispatchQueue.main.async(execute: {
            
            let dataDirectionsResult = NSData(contentsOf: urlDirectionsRequest!)
            
            do {
                
                let dictDirectionResult: Dictionary<String,AnyObject> = try JSONSerialization.jsonObject(with: dataDirectionsResult as! Data, options: .mutableContainers) as! [String : AnyObject]
                let status = dictDirectionResult["status"] as! String
                if status == "OK" {
                    
                    self.arrSelectedRoute = dictDirectionResult["routes"] as! Array<Dictionary<String, AnyObject>>
                    
                    var arrRoutes: [Routes] = []
                    for dicTmp in self.arrSelectedRoute
                    {
                        let legs = dicTmp?["legs"] as! Array<Dictionary<String, AnyObject>>
                        let dictLegTmp = legs[0] as [String:AnyObject]
                        
                        let strRouteName = dicTmp?["summary"] as! String
                        let dictTmpRouteOverAllPoint = dicTmp?["overview_polyline"] as! [String:String]
                        let strRouteOverAllPoints = dictTmpRouteOverAllPoint["points"]

                        let strSource = legs[0]["start_address"] as! String
                        let strDestination = legs[legs.count - 1]["end_address"] as! String
                        
                        let dictTmpRouteDistance = dictLegTmp["distance"] as! [String : Any]
                        let strRouteDistance = dictTmpRouteDistance["text"]! as! String
                        
                        let dictTmpRouteTime = dictLegTmp["duration"] as! [String : Any]
                        let strRouteTime = dictTmpRouteTime["text"]! as! String
                        
                        let arrCoordAndPoints = self.getAllCoordinatesAndPointsAlongRoute(route: dicTmp!)
                        
                        let route = Routes(routeName: strRouteName, routeDistance: strRouteDistance, routeTime: strRouteTime, routeSource: strSource, routeDestination: strDestination)
                        route.strRouteOverllPoints = strRouteOverAllPoints
                        route.arrRouteLatLong = arrCoordAndPoints.0
                        route.arrRoutePoints = arrCoordAndPoints.1
                        arrRoutes.append(route)
                        
                    }
                    
                    completionHandler(status, true, arrRoutes)
                }
                else {
                    completionHandler(status, false, nil)
                }
            }catch{
                
            }
            
        })
        
    }
}

