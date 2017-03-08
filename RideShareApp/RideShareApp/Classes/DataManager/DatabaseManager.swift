//
//  DatabaseManager.swift
//  RideShareApp
//
//  Created by Sravan on 26/02/17.
//  Copyright © 2017 Tcs. All rights reserved.
//

import Foundation
import FirebaseDatabase
import GoogleMaps

class DatabaseManager: NSObject {
    var dbRef: FIRDatabaseReference!
    let rootNode: String = "RideShareAppData"
    let userNode: String = "User"
    let rideNode: String = "Ride"
    let rideDataNode: String = "RidesData"
    let vehicleDataNode: String = "VehicleData"
    
    var rideNodeRef: FIRDatabaseReference
    var userNodeRef: FIRDatabaseReference
    
    let testRef = FIRDatabase.database().reference(withPath: "RideShareAppData/User/kanyainfogmailcom/OpenRide")
    
    override init() {
        dbRef = FIRDatabase.database().reference()
        rideNodeRef = dbRef.child("RideShareAppData/Ride")
        userNodeRef = dbRef.child("RideShareAppData/User")
        
        super.init()
        
    }
    
    func saveUserProfileData(user: User) {
        
        guard !(user.userEmail?.isEmpty)! else {
            print("User Data is empty. Not saving to database")
            return
        }
        
        let vehicleData = [
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
            "VehicleOwner" : user.userVehicle.isVehicleOwner,
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
        user.userId = formattedEmail
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
    
    func saveRideData(ride: Rides, completionHandler: @escaping (String) -> ()) {
        
        //MARK Completion Handler/Return to be created
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy hh:mm a"
        let dateFormatterId = DateFormatter()
        dateFormatterId.dateFormat = "ddMMyyhhmma"
        
        let strStartTime = Utils.sharedInstance.getFormattedStringFromDate(date:ride.rideStartTime!)
        
        let strId = dateFormatterId.string(from: ride.rideStartTime!)
        
        let userDefaults = UserDefaults.standard
        let userId = userDefaults.object(forKey: "User")
        
        let rideData = [
            "RideStartingPoint" : ride.rideSource ,
            "RideEndingPoint" : ride.rideDestination ,
            "RideStartingTime" : strStartTime ,
            "RideEndingTime" : ride.rideEndTime ?? "01-01-1990" ,
            "RideRoute" : ride.rideRouteName,
            "RideRouteLine" : ride.strRouteOverllPoints!,
            "RideLatLong" : ride.arrRouteLatLong!,
            "RidePoints" : ride.arrRoutePoints!,
            "Number_of_free_seats": ride.iSeatAvailable!
            ] as [String : Any]
        
        let tmpRef = userNodeRef.child(userId as! String)
            .child(vehicleDataNode)
        
        tmpRef.observeSingleEvent(of: .value, with: { [unowned self](snapshot) in
            let dictTmp = snapshot.value as! [String:Any]
            var vehicleNumber = dictTmp["VehicleNumber"] as! String
            let formattedRideId =  String(vehicleNumber.characters.filter {
                $0 != " "
            }) + strId
            self.rideNodeRef.child(formattedRideId)
                .setValue(rideData, withCompletionBlock: {
                    (error: Error?, ref:FIRDatabaseReference!) in
                    print("Ride data Created")
                    completionHandler(formattedRideId)
                    if let error = error {
                        print("Error: while creating data in DB : \(error.localizedDescription)")
                    }
                })
            self.userNodeRef.child(userId as! String)
                .child(self.rideDataNode)
                .updateChildValues(["OpenRide":formattedRideId], withCompletionBlock:
                    { (error: Error?, ref:FIRDatabaseReference!) in
                        print("Open Ride data Created")
                        
                        if let error = error {
                            print("Error: while creating data in DB : \(error.localizedDescription)")
                        }
                })
            
        })
        
    }
    
    func getOpenRide(completionHandler:@escaping (String?) -> ()) -> ()
    {
        let userDefaults = UserDefaults.standard
        let userId = userDefaults.object(forKey: "User")
        dbRef.child(rootNode)
            .child(userNode)
            .child(userId as! String)
            .child(rideDataNode)
            .observeSingleEvent(of: .value, with: {(snapshot) in
                let dictTmp = snapshot.value as! [String:Any]
                let strOpenRide = dictTmp["OpenRide"] as? String
                completionHandler(strOpenRide)
                
            })
    }
    
    
    func getRideData(completionHandler: @escaping (Rides?,Bool) -> ()) -> () {
        
        self.getOpenRide(completionHandler: { (rideOpen) in
            
            guard let openRide = rideOpen else {
                completionHandler(nil,false)
                return
            }
            self.dbRef.child(self.rootNode)
                .child(self.rideNode)
                .child(openRide).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let dictTmp = snapshot.value as! [String:Any]
                    let strSource = dictTmp["RideStartingPoint"] as! String
                    let strDestination = dictTmp["RideEndingPoint"] as! String
                    let strRoute = dictTmp["RideRoute"] as! String
                    let strRouteLine = dictTmp["RideRouteLine"] as! String
                    let arrRouteLatLong = dictTmp["RideLatLong"] as! [String]
                    let arrRoutePonts = dictTmp["RidePoints"] as! [String]
                    let strStartTime = dictTmp["RideStartingTime"] as! String
                    let strEndTime = dictTmp["RideEndingTime"] as! String
                    
                    
                    
                    let ride = Rides()
                    ride.strRideId = openRide
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yy hh:mm a"
                    let dtStartTime = dateFormatter.date(from: strStartTime)
                    let dtEndTime = dateFormatter.date(from: strEndTime)
                    
                    ride.rideSource = strSource
                    ride.rideDestination = strDestination
                    ride.rideRouteName = strRoute
                    ride.strRouteOverllPoints = strRouteLine
                    ride.arrRouteLatLong = arrRouteLatLong
                    ride.arrRoutePoints = arrRoutePonts
                    ride.rideStartTime = dtStartTime
                    ride.rideEndTime = dtEndTime
                    if let arrPassenger = dictTmp["PassengerData"]  {
                        let arrPaxTmp = arrPassenger as! [String:String]
                        var arrTmp: [String] = []
                        for dict in arrPaxTmp {
                            arrTmp.append(dict.value)
                        }
                        ride.arrPassengerDestinations = arrTmp
                    }
                    
                    completionHandler(ride,true)
                })
        })
        
    }
    
    func getAllRidesWithSource(source: String, andTime startTime: Date, andDestination destination: CLLocationCoordinate2D?, completionHandler: @escaping ([Routes]) -> ()) -> () {
        
        
        let strStartTime = Utils.sharedInstance.getFormattedStringFromDate(date: startTime)
        
        let query =  self.dbRef.child(self.rootNode)
            .child(self.rideNode).queryOrdered(byChild: "RideStartingPoint").queryEqual(toValue: source)
        
        
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let dictSnapshot = snapshot.value as! [String:Any]
            for element in dictSnapshot.keys {
                let dictTmp = dictSnapshot[element] as! [String:AnyObject]
                let strTmp = dictTmp["RideStartingTime"] as! String
                if (strTmp == strStartTime) {
                    let route = dictTmp["RideRouteLine"] as! String
                    let path: GMSPath = GMSPath(fromEncodedPath: route)!
                    let rideMap: GMSMapView = GMSMapView()
                    let routePolyline = GMSPolyline(path: path)
                    routePolyline.map = rideMap
                    let bIsAvailable:Bool = GMSGeometryIsLocationOnPathTolerance(destination!, path, true,1000)
                    if(true) {
                        var arrRides:[Routes] = []
                        let strSource = dictTmp["RideStartingPoint"] as! String
                        let strDestination = dictTmp["RideEndingPoint"] as! String
                        let strRoute = dictTmp["RideRoute"] as! String
                        let strStartTime = dictTmp["RideStartingTime"] as! String
                        let route = Routes(routeName: strRoute, routeDistance: nil, routeTime: strStartTime, routeSource: strSource, routeDestination: strDestination)
                        route.strRideId = element
                        route.iNumberOfSeats = dictTmp["Number_of_free_seats"] as! Int
                        
                        self.userNodeRef.observeSingleEvent(of: .value, with: { (snapshot) in
                            let userSnapshot = snapshot.value as! [String:AnyObject]
                            for userElement in userSnapshot.keys {
                                let dictTmp1 = userSnapshot[userElement] as! [String:AnyObject]
                                let isDriver = dictTmp1["VehicleOwner"] as! Bool
                                if(isDriver) {
                                    let userquery =  self.userNodeRef.child(userElement).child("RidesData/OpenRide")
                                    userquery.observeSingleEvent(of: .value, with: { (snapshot) in
                                        let strOpenRide = snapshot.value as! String
                                        if(strOpenRide == element)
                                        {
                                            route.strUserName = dictTmp1["GivenName"] as? String
                                            route.strUserEmail = dictTmp1["Email"] as? String
                                            let dictTmpVehicleDate = dictTmp1["VehicleData"] as! [String:Any]
                                            route.strUserVehicle = dictTmpVehicleDate["VehicleNumber"] as? String
                                            arrRides.append(route)
                                            completionHandler(arrRides)
                                            
                                        }
                                        //                                    for element in dictSnapshot1.keys {
                                        //                                        let dictTmp1 = dictSnapshot1[element] as! [String:AnyObject]
                                        //                                    }
                                        //
                                    })
                                }
                                
                            }
                            
                        })
                        
                        
                    }
                }
            }
            
        })
    }
    
    
    func savePassengerRideData(strRideId: String, seatRequired: Int,destination: String, completionHandler: @escaping (Bool) -> ()) {
        let rideReference = self.rideNodeRef.child(strRideId)
        rideReference.observeSingleEvent(of: .value, with: { (snapshot) in
            let userSnapshot = snapshot.value as! [String:AnyObject]
            let iSeatsAvailable = userSnapshot["Number_of_free_seats"] as! Int
            let newVal = iSeatsAvailable-seatRequired
            if(newVal < 0) {
                completionHandler(false)
            } else {
                let newData = ["Number_of_free_seats":newVal]
                rideReference.updateChildValues(newData)
                let userDefaults = UserDefaults.standard
                let userId = userDefaults.object(forKey: "User")
                let passengerData = [userId as! String:destination] as [String:String]
                rideReference.child("PassengerData").updateChildValues(passengerData, withCompletionBlock: { (error: Error?, ref:FIRDatabaseReference!) in
                    print("Passenger Ride data Created")
                    completionHandler(true)
                    if let error = error {
                        print("Error: while creating data in DB : \(error.localizedDescription)")
                    }
                })
                self.userNodeRef.child(userId as! String)
                    .child(self.rideDataNode)
                    .updateChildValues(["OpenRide":strRideId], withCompletionBlock:
                        { (error: Error?, ref:FIRDatabaseReference!) in
                            print("Open Ride data Created")
                            
                            if let error = error {
                                print("Error: while creating data in DB : \(error.localizedDescription)")
                            }
                    })
                
            }
            
        })
    }
    func observeForAvailableSeats(rideId: String, completionHandler:@escaping ([String:String],Int,Bool) -> ()) {
        
        self.rideNodeRef.child(rideId)
            .child("Number_of_free_seats")
            .observe(.value, with: { snapshot in
                let seatCount = snapshot.value as! Int
                self.rideNodeRef.child(rideId)
                    .child("PassengerData").observeSingleEvent(of: .value, with: { passengerSnapshot in
                        if(passengerSnapshot.exists()){
                            let passengetDetail = passengerSnapshot.value as! [String:String]
                            completionHandler(passengetDetail,seatCount,true)
                            
                        }
                        
                    })
            })
    }
    
    func isVehicleOwner(completionHandler:@escaping (Bool) -> ()) {
        
        
        let userDefaults = UserDefaults.standard
        let userId = userDefaults.object(forKey: "User")
        self.userNodeRef.child(userId as! String)
            .child("VehicleOwner")
            .observe(.value, with: { snapshot in
                let isVehicleOwner = snapshot.value as! Bool
                completionHandler(isVehicleOwner)
            })
    }
    
    func updateCoordForRide(rideId: String,coord: String) {
        self.rideNodeRef.child(rideId)
            .updateChildValues(["CurrentCoord":coord], withCompletionBlock: { (error: Error?, ref:FIRDatabaseReference!) in
                print("Live Coordinates updated")
                
                if let error = error {
                    print("Error: while creating data in DB : \(error.localizedDescription)")
                }
            })
    }
    func observeForLocChange(rideId: String, completionHandler:@escaping (String,Bool) -> ()) {
        
        self.rideNodeRef.child(rideId)
            .child("CurrentCoord")
            .observe(.value, with: { snapshot in
                if(snapshot.exists())
                {
                    let coord = snapshot.value as! String
                    completionHandler(coord,true)
                }

            })
    }


}
