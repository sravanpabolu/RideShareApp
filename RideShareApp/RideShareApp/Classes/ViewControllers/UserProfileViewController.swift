//
//  UserProfileViewController.swift
//  RideShareApp
//
//  Created by Sravan on 23/02/17.
//  
//

import Foundation
import UIKit

class UserProfileViewController: BaseViewController {
    
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtName:UITextField!
    @IBOutlet weak var txtGender:UITextField!
    @IBOutlet weak var txtSource:UITextField!
    @IBOutlet weak var txtDestination:UITextField!
    @IBOutlet weak var txtVehicleNumber:UITextField!
    @IBOutlet weak var txtVehicleModel:UITextField!
    @IBOutlet weak var switchIsOwner:UISwitch!
    
    let user = User.sharedInstance
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        user.userEmail  = txtEmail.text
        user.userName   = txtName.text
        user.userGender = txtGender.text
        
        user.userVehicle.isVehicleOwner    = switchIsOwner.isOn
        user.userVehicle.vehicleNumber     = txtVehicleNumber.text
        user.userVehicle.vehicleModel      = txtVehicleModel.text
        user.userVehicle.vehicleSource     = txtSource.text
        user.userVehicle.vehicleDestination = txtDestination.text
        
        saveToDB()
    }
    
    func saveToDB() {
        let dbManager = DatabaseManager()
        dbManager.saveUserProfileData(user: user)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
