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
    let userNode: String = "User"
    
    override init() {
        super.init()
        dbRef = FIRDatabase.database().reference()
    }
    
    func saveUserProfileData(user: User) {
        
        guard !(user.userEmail?.isEmpty)! else {
            return
        }
        
        let userData = [
            "Email"         : user.userEmail as Any,
            "Given Name"    : user.userName as Any,
            "Gender"        : user.userGender as Any,
            "Vehicle Owner" : user.userVehicle.isVehicleOwner as Any,
            "Vehicle Number" : user.userVehicle.vehicleNumber as Any,
            "Vehicle Model" : user.userVehicle.vehicleModel as Any,
            "Vehicle Source" : user.userVehicle.vehicleSource as Any,
            "Vehicle Destination" : user.userVehicle.vehicleDestination as Any
        ] as [String : Any]
        
        /*
         Format : 
         "User": {
            "user_id_is_the_email": {
            "Given_Name": "John Smith",
            "Contact_number": 9988998898,
            "Gender": "Male",
            }
         }
         */
        
        
        dbRef.child(rootNode)
            .child(userNode)
            .child(user.userEmail!)
            .setValue(userData, withCompletionBlock:
                { (error: Error?, ref:FIRDatabaseReference!) in
                    print("User data Created")
                    
                    if let error = error {
                        print("Error: while creating data in DB : \(error.localizedDescription)")
                    }
            }

        
//        dbRef.child(rootNode).setValue(userData, withCompletionBlock: { (error: Error?, ref:FIRDatabaseReference!) in
//            print("User data Created")
//            
//            if let error = error {
//                print("Error: while creating data in DB : \(error.localizedDescription)")
//            }
//        }
        )
        
        
        }
    
    
    /*
     
     func saveUserProfileData(user: User) {
     
     guard !(user.userEmail?.isEmpty)! else {
     return
     }
     
     if let emailString = user.userEmail {
     
     let formattedEmail = Utils.sharedInstance.trimCharacters(sourceString: emailString)
     
     //            let owner   = user.userVehicle.isVehicleOwner as Any
     //            let vNum    = user.userVehicle.vehicleNumber as Any,
     //            "VehicleModel"  : user.userVehicle.vehicleModel as Any,
     //            "VehicleSource" : user.userVehicle.vehicleSource as Any,
     //            "VehicleDestination" : user.userVehicle.vehicleDestination  as Any
     
     let vehicleData =
     
     Dictionary(dictionaryLiteral:
     "VehicleOwner"  , user.userVehicle.isVehicleOwner as Any,
     "VehicleNumber" , user.userVehicle.vehicleNumber as Any,
     "VehicleModel"  , user.userVehicle.vehicleModel as Any,
     "VehicleSource" , user.userVehicle.vehicleSource as Any,
     "VehicleDestination" , user.userVehicle.vehicleDestination  as Any
     )
     
     //                Dictionary (
     //                [
     //                "VehicleOwner"  : user.userVehicle.isVehicleOwner as Any,
     //                "VehicleNumber" : user.userVehicle.vehicleNumber as Any,
     //                "VehicleModel"  : user.userVehicle.vehicleModel as Any,
     //                "VehicleSource" : user.userVehicle.vehicleSource as Any,
     //                "VehicleDestination" : user.userVehicle.vehicleDestination  as Any
     //                ]
     //            )
     
     //            let userData = Dictionary (
     //                [
     //                "UserID"        : formattedEmail,
     //                "Email"         : emailString,
     //                "GivenName"     : user.userName as Any,
     //                "Gender"        : user.userGender as Any,
     //                "ContactNumber" : user.userContactNumber as Any,
     //                "VehicleDetails": vehicleData
     //                ] as [String : Any]
     //            )
     
     /*
     Format :
     "User": {
     "user_id_is_the_email": {
     "Given_Name": "John Smith",
     "Contact_number": 9988998898,
     "Gender": "Male",
     "VehicleDetails":{
     
     }
     }
     }
     */
     
     
     
     
     
     
     
     
     //            dbRef.child(rootNode)
     //                .child(userNode)
     //                .child(formattedEmail)
     //                .setValue(userData, withCompletionBlock:
     //                    { (error: Error?, ref:FIRDatabaseReference!) in
     //                        print("User data Created")
     //
     //                        if let error = error {
     //                            print("Error: while creating data in DB : \(error.localizedDescription)")
     //                        }
     //                })
     }
     }
     */
}
