//
//  HomeViewController.swift
//  RideShareApp
//
//  Created by Sravan on 23/02/17.
//  
//

import Foundation
import UIKit

class HomeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var homeScreenTable: UITableView!
    
    var tableData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeScreenTable.backgroundColor = UIColor.black
        homeScreenTable.layer.masksToBounds = true
        homeScreenTable.layer.borderColor = UIColor( red: 153/255, green: 153/255, blue:0/255, alpha: 1.0 ).cgColor
        homeScreenTable.layer.borderWidth = 2.0
        
        tableData = ["Signin/Signout", "My Profile",
                     "Book Ride", "Go Ride",
                     "My Rides",
                     "Credits", "About"
                    ]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = tableData[indexPath.row]
        cell.textLabel?.backgroundColor = UIColor.black
        cell.textLabel?.textColor = UIColor.white
        cell.contentView.backgroundColor = UIColor.black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var destinationController : UIViewController
        let storyboard = UIStoryboard(name: "RideShareApp", bundle: Bundle.main)
        
        switch indexPath.row {
        case 0:
            //Signin / Signout
            destinationController = storyboard.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
        case 1:
            //User Profile
            destinationController = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        case 2:
            //Book Ride
            destinationController = storyboard.instantiateViewController(withIdentifier: "BookRideViewController") as! BookRideViewController
        case 3:
            //Go Ride
            destinationController = storyboard.instantiateViewController(withIdentifier: "GoRideViewController") as! GoRideViewController
        case 4:
            //Go Ride
            destinationController = storyboard.instantiateViewController(withIdentifier: "MyRidesViewController") as! MyRidesViewController
        case 5:
            //Credits
            destinationController = storyboard.instantiateViewController(withIdentifier: "CreditsViewController") as! CreditsViewController
        case 6:
            //About
            destinationController = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController

        default:
            destinationController = UIViewController()
            print("None Selected in the table")
        
        }
        
        navigationController?.pushViewController(destinationController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
