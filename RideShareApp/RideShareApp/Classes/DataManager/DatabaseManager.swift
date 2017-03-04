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
    let userNode: String = "UserData"
    let rideNode: String = "Ride"

    override init() {
        super.init()
        dbRef = FIRDatabase.database().reference()
    }
    
    func saveUserProfileData(user: User) {
        
        guard !(user.userEmail?.isEmpty)! else {
            print("User Data is empty. Not saving to database")
            return
        }
        
        let vehicleData = [
                "VehicleOwner" : user.userVehicle.isVehicleOwner,
                "VehicleNumber" : user.userVehicle.vehicleNumber,
                "VehicleModel" : user.userVehicle.vehicleModel,
                "VehicleSource" : user.userVehicle.vehicleSource,
                "VehicleDestination" : user.userVehicle.vehicleDestination
        ] as [String : Any]
        
        let rideData = [
            "RideStartingPoint" : user.userRides.rideSource ,
            "RideEndingPoint" : user.userRides.rideDestination ,
            "RideStartingTime" : user.userRides.rideStartTime ?? "01-01-1990" ,
            "RideEndingTime" : user.userRides.rideEndTime ?? "01-01-1990" ,
            "RideRoute" : user.userRides.rideRouteName 
        ] as [String : Any]
        
        let userData = [
            "Email"         : user.userEmail as Any ,
            "GivenName"     : user.userName as Any,
            "Gender"        : user.userGender ,
            "ContactNumber" : user.userContactNumber ,
            "VehicleData"   : vehicleData,
            "RidesData"     : rideData
            ] as [String : Any]
        
        
        print("User Data: \(userData)")

//        let userData = [
//            "Email"         : user.userEmail as Any,
//            "Given Name"    : user.userName as Any,
//            "Gender"        : user.userGender as Any,
//            "VehicleOwner" : user.userVehicle.isVehicleOwner as Any,
//            "VehicleNumber" : user.userVehicle.vehicleNumber as Any,
//            "VehicleModel" : user.userVehicle.vehicleModel as Any,
//            "VehicleSource" : user.userVehicle.vehicleSource as Any,
//            "VehicleDestination" : user.userVehicle.vehicleDestination as Any
//        ] as [String : Any]
        
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
        
        let formattedEmail = Utils.sharedInstance.trimCharacters(sourceString: user.userEmail!)
        dbRef.child(rootNode)
            .child(userNode)
            .child(formattedEmail)
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
    
    func saveRideData(ride: Rides) {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy hh:mm a"
        let dateFormatterId = DateFormatter()
        dateFormatterId.dateFormat = "ddMMyyhhmma"

        
        let strStartTime = dateFormatter.string(from: ride.rideStartTime!)
        let strId = dateFormatterId.string(from: ride.rideStartTime!)

        let rideData = [
            "RideStartingPoint" : ride.rideSource ,
            "RideEndingPoint" : ride.rideDestination ,
            "RideStartingTime" : strStartTime ,
            "RideEndingTime" : ride.rideEndTime ?? "01-01-1990" ,
            "RideRoute" : ride.rideRouteName,
            "RideRouteLine" : ride.strRouteOverllPoints!,
//            "RideLatLong" : ride.arrRouteLatLong!,
            "RidePoints" : ride.arrRoutePoints!
            ] as [String : Any]

        
        //MARK: To be changed
        let formattedRideId = strId
        
        dbRef.child(rootNode)
            .child(rideNode)
            .child(formattedRideId)
            .setValue(rideData, withCompletionBlock: {
                (error: Error?, ref:FIRDatabaseReference!) in
                    print("Ride data Created")
                    if let error = error {
                        print("Error: while creating data in DB : \(error.localizedDescription)")
                    }
            })

    }
    
//    func getRideData(ride: Rides) {
//        dbRef.child(rootNode)
//            .child(rideNode).obser
//
//        
//    }
}
