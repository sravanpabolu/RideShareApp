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
    public var userGender:String = "NA"
    public var userContactNumber:IntMax = 9999999999
    
    public var userVehicle:Vehicle = Vehicle()
    public var userRides:Rides = Rides()
    
    public static var sharedInstance = User()
    
    override init() {
        super.init()
    }
}
