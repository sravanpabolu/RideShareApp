//
//  DatabaseOperationsViewController.swift
//  RideShareApp
//
//  Created by Sravan on 16/02/17.
//  Copyright © 2017 Tcs. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DatabaseOperationsViewController: BaseViewController {
    
    var dbRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:
    //MARK: should remove the following method.
    //MARK:
    
    @IBAction func btnPlacesTapped(_ sender: Any) {
        let textFieldAutoComplete = AutocompleteWithTextFieldController()
        present(textFieldAutoComplete, animated: true, completion: nil);
    }
      
    //MARK:
    //MARK: Button action methods
    @IBAction func btnCreateTapped(_ sender: Any) {
        self.dbRef.child("User 1").setValue(["First Name" : "Sravan"])
        
        let user2Data = ["First Name" : "Nirosha" ,
                         "Last Name" : "P"]
        
        self.dbRef.child("User 2").setValue(user2Data, withCompletionBlock: { (error: Error?, ref:FIRDatabaseReference!) in
            print("Create data for User 2")
            
            if let error = error {
                print("Error : \(error.localizedDescription)")
            }
        })
    }
    
    @IBAction func btnRetrieveTapped(_ sender: Any) {
        self.dbRef.child("User 1").observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot: FIRDataSnapshot) in
            let user1Data = snapshot.value as! NSDictionary
            
            print("User 1 Data : \n \(user1Data)")
        })
    }
    
    @IBAction func btnUpdateTapped(_ sender: Any) {
        self.dbRef.child("User 1").updateChildValues(["Last Name" : "Kumar"], withCompletionBlock: { (error: Error?, ref:FIRDatabaseReference!) in
            print("Update data for User 1")
            
            if let error = error {
                print("Error : \(error.localizedDescription)")
            }
        })

    }
    
    @IBAction func btnDeleteTapped(_ sender: Any) {
        self.dbRef.child("User 1").removeValue(completionBlock: { (error: Error?, ref:FIRDatabaseReference!) in
            print("Delete data for User 1")
            
            if let error = error {
                print("Error : \(error.localizedDescription)")
            }
        })
    }
    
}

