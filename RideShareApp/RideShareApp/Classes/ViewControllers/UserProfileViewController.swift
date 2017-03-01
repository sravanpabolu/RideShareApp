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
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    
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
        
        //TODO: Add closure to determine success or failure
        //if success, goto homeviewcontroller
        //if failure, show error
//        _ = navigationController?.popToRootViewController(animated: true)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //Mark:
    @IBAction func switchValueChanged(sender: UISwitch) {
        if sender.isOn {
            txtVehicleNumber.isHidden = false
            txtVehicleModel.isHidden = false
            stackViewHeightConstraint.constant = 290
        } else {
            txtVehicleNumber.isHidden = true
            txtVehicleModel.isHidden = true
            stackViewHeightConstraint.constant = 360
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Switch functionality
//        switchIsOwner.addTarget(self, action: Selector("switchValueChanged:"), for: UIControlEvents.valueChanged)
        
        //auto generate, if user already signed in.
        if let email = user.userEmail {
            txtEmail.text = email
            txtEmail.isUserInteractionEnabled = false
        }
        
        if let name = user.userName {
            txtName.text = name
            txtName.isUserInteractionEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
