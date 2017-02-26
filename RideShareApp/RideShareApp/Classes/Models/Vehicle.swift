//
//  Vehicle.swift
//  RideShareApp
//
//  Created by Sravan on 26/02/17.
//  
//

import Foundation

class Vehicle: NSObject {
    
    public var isVehicleOwner:Bool?
    public var vehicleNumber: String?
    public var vehicleModel : String?
    public var numberOfFreeSeats: Int?
    public var vehicleRoute:String?
    public var vehicleSource: String?
    public var vehicleDestination: String?
    
    override init(){
        super.init()
    }
}
