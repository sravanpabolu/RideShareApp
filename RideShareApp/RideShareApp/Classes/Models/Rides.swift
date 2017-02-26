//
//  Rides.swift
//  RideShareApp
//
//  Created by Sravan on 26/02/17.
//  
//

import Foundation

class Rides: NSObject {
    
    public var rideSource:String?
    public var rideDestination:String?
    public var rideStartTime:Date?
    public var rideEndTime:Date?
    public var rideRouteName:String?
    
    override init() {
        super.init()
    }
}
