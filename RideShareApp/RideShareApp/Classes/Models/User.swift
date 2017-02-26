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
    
    //TODO: Do we need this statement ?
    public var isUserSigninSuccess:Bool?
    
    public var userVehicle:Vehicle?
    public var userRides:Rides?
    
    public static var sharedInstance = User()
    
    override init() {
        super.init()
    }
}
