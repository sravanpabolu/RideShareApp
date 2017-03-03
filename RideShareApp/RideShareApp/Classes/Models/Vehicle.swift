//
//  Vehicle.swift
//  RideShareApp
//
//  Created by Sravan on 26/02/17.
//  
//

import Foundation

class Vehicle: NSObject {
    
    public var isVehicleOwner:Bool = false
    public var vehicleNumber: String = "NA"
    public var vehicleModel : String = "NA"
    public var numberOfFreeSeats: Int = 1
    public var vehicleRoute:String = "NA"
    public var vehicleSource: String = "NA"
    public var vehicleDestination: String = "NA"
    
    override init(){
        super.init()
    }
}
