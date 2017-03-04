//
//  Routes.swift
//  RideShareApp
//
//  Created by Kanya Rajan on 3/3/17.
//  Copyright © 2017 Tcs. All rights reserved.
//

import Foundation
import CoreLocation

class Routes: NSObject {
    
    public var strRouteName: String
    public var strRouteDistance: String
    public var strRouteTime: String
    public var strRouteSource: String
    public var strRouteDestination: String
    public var strRouteOverllPoints: String?
    public var arrRoutePoints: [String]?
    public var arrRouteLatLong: [CLLocationCoordinate2D]?
    public var arrRouteL: [CLLocationCoordinate2D]?


    init(routeName: String, routeDistance: String, routeTime: String, routeSource: String, routeDestination: String) {
        
        self.strRouteName = routeName
        self.strRouteDistance = routeDistance
        self.strRouteTime = routeTime
        self.strRouteSource = routeSource
        self.strRouteDestination = routeDestination
        super.init()
        
    }
}
