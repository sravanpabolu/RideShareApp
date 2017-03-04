//
//  Routes.swift
//  RideShareApp
//
//  Created by Kanya Rajan on 3/3/17.
//  Copyright © 2017 Tcs. All rights reserved.
//

import Foundation

class Routes: NSObject {
    
    public var strRouteName:String
    public var strRouteDistance:String
    public var strRouteTime:String
    
    init(routeName: String, routeDistance: String, routeTime: String) {
        self.strRouteName = routeName
        self.strRouteDistance = routeDistance
        self.strRouteTime = routeTime
        super.init()

    }
}
