//
//  Rides.swift
//  RideShareApp
//
//  Created by Sravan on 26/02/17.
//
//

import Foundation

class Rides: NSObject {
    
    public var strRideId: String?
    public var rideSource:String = "NA"
    public var rideDestination:String = "NA"
    public var rideStartTime:Date?
    public var rideEndTime:Date?
    public var rideRouteName:String = "NA"
    public var strRouteOverllPoints: String?
    public var arrRoutePoints: [String]?
    public var arrRouteLatLong: [String]?
    public var arrPassengerDestinations: [String]?
    
    public var iSeatAvailable: Int?
    
    public var strSrcCoord: CLLocationCoordinate2D? {
        
        guard let strSrc = arrRouteLatLong?[0] else {
            return nil
        }
        let arrTmp = strSrc.characters.split{$0 == ","}.map(String.init)
        let coord = CLLocationCoordinate2DMake(Double(arrTmp[0])! ,
                                               Double(arrTmp[1])!)
        return coord
        
    }
    
    public var strDesCoord: CLLocationCoordinate2D? {
        
        guard let strDes = arrRouteLatLong?[(arrRouteLatLong?.count)!-1] else {
            return nil
        }
        let arrTmp = strDes.characters.split{$0 == ","}.map(String.init)
        let coord = CLLocationCoordinate2DMake(Double(arrTmp[0])! ,
                                               Double(arrTmp[1])!)
        return coord
        
    }
    
    override init() {
        super.init()
    }
    
    
}
