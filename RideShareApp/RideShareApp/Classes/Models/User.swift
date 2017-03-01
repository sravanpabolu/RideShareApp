//
//  User.swift
//  RideShareApp
//
//  Created by Sravan on 26/02/17.
//  
//

import Foundation

class User: NSObject {
    
    public var userName:String?
    public var userEmail:String?
    public var userGender:String?
    public var userContactNumber:IntMax?
    
    public var userVehicle:Vehicle = Vehicle()
    public var userRides:Rides = Rides()
    
    public static var sharedInstance = User()
    
    override init() {
        super.init()
    }
}
