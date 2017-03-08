//
//  BookRideViewController.swift
//  RideShareApp
//
//  Created by Sravan on 23/02/17.
//
//

import Foundation
import UIKit
import GooglePlaces

class BookRideViewController: BaseViewController, GMSAutocompleteViewControllerDelegate {
    
    @IBOutlet weak var btnSource: UIButton!
    @IBOutlet weak var btnDestination: UIButton!
    @IBOutlet weak var txtNumberOfSeats: UITextField!
    @IBOutlet weak var pickerBookingDate: UIDatePicker!
    
    var currentButton:UIButton?
    var bookedDate:Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerBookingDate.setValue(UIColor.white, forKey: "textColor");
//        pickerBookingDate.minimumDate = Date()
        pickerBookingDate.addTarget(self, action: #selector(setBookingTime(pickerVal:)) , for: UIControlEvents.valueChanged)
    }
    
    //MARK: Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setBookingTime(pickerVal:UIDatePicker) {
        
        self.bookedDate = pickerVal.date
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //        guard ((txtSource.text?.characters.count)! > 0) && ((txtDestination.text?.characters.count)! > 0) && ((txtNumberOfSeats.text?.characters.count)! > 0) else {
        //            let alertUser = UIAlertController(title: "Missing Values", message: "Please enter Source, Destination and Number of Seats", preferredStyle: .alert)
        //            alertUser.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //            self.present(alertUser, animated: true, completion: nil)
        //            return
        //        }
        
        let vc = segue.destination as! RouteListViewController
        vc.strSource = "Siruseri, Tamil Nadu"
        vc.strDestination = "Velachery, Chennai, Tamil Nadu"
        vc.iNumberOfSeats = Int(txtNumberOfSeats.text!)
        vc.dtBookingDate = self.bookedDate
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
    }
    
    @IBAction func btnSourceTapped(sender: UIButton) {
        currentButton = sender
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self;
        
        _ = navigationController?.pushViewController(autoCompleteController, animated: false)
    }
    
    //MARK: Autocomplete place delegate methods
    public func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Selected Place: \(place.name)")
        
        currentButton?.titleLabel?.text = place.name
        _ = navigationController?.popViewController(animated: true)
    }
    
    public func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error while searching place : \(error.localizedDescription)")
        _ = navigationController?.popViewController(animated: true)
        showAlert(title: "Error", message: error.localizedDescription)
    }
    
    public func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Place Selection Cancelled")
        _ = navigationController?.popViewController(animated: true)
    }
}
