//
//  DatabaseManager.swift
//  RideShareApp
//
//  Created by Sravan on 26/02/17.
//  Copyright © 2017 Tcs. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DatabaseManager: NSObject {
    var dbRef: FIRDatabaseReference!
    let rootNode: String = "RideShareAppData"
    override init() {
        super.init()
        dbRef = FIRDatabase.database().reference()
    }
    
    func saveUserProfileData(user: User) {
        
        let userData = [
            "Email"         : user.userEmail as Any,
            "Name"          : user.userName as Any,
            "Gender"        : user.userGender as Any,
            "Vehicle Owner" : user.userVehicle.isVehicleOwner as Any,
            "Vehicle Number" : user.userVehicle.vehicleNumber as Any,
            "Vehicle Model" : user.userVehicle.vehicleModel as Any,
            "Vehicle Source" : user.userVehicle.vehicleSource as Any,
            "Vehicle Destination" : user.userVehicle.vehicleDestination as Any
        ] as [String : Any]
        
        dbRef.child(rootNode).setValue(userData, withCompletionBlock: { (error: Error?, ref:FIRDatabaseReference!) in
            print("User data Created")
            
            if let error = error {
                print("Error: while creating data in DB : \(error.localizedDescription)")
            }
        }
        )
        
        
        }
}
