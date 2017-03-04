//
//  Rides.swift
//  RideShareApp
//
//  Created by Sravan on 26/02/17.
//  
//

import Foundation

class Rides: NSObject {
    
    public var rideSource:String = "NA"
    public var rideDestination:String = "NA"
    public var rideStartTime:Date?
    public var rideEndTime:Date?
    public var rideRouteName:String = "NA"
    
    override init() {
        super.init()
    }
}
