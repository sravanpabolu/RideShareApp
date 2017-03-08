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

class BookRideViewController: BaseViewController, GMSAutocompleteViewControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var txtSource: UITextField!
    @IBOutlet weak var txtDestination: UITextField!
    @IBOutlet weak var txtNumberOfSeats: UITextField!
    @IBOutlet weak var pickerBookingDate: UIDatePicker!
    
    var currentTag : Int = 10
    var bookedDate:Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleSeatChangeNotification), name: NSNotification.Name(rawValue: "SeatChangeNotification"), object: nil)
        
        pickerBookingDate.setValue(UIColor.white, forKey: "textColor");
        //        pickerBookingDate.minimumDate = Date()
        pickerBookingDate.addTarget(self, action: #selector(setBookingTime(pickerVal:)) , for: UIControlEvents.valueChanged)
        
        self.txtSource.delegate = self
        self.txtDestination.delegate = self
    }
    
    //MARK: Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: UITextFieldDelegate methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        //Do not show autocomplete controller for number of seats text field
        if textField == txtNumberOfSeats {
            return true
        }
        
        currentTag = textField.tag
        
        //Show autocomplete controller
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self;
        _ = navigationController?.pushViewController(autoCompleteController, animated: true)
        
        return false
    }
    
    func setBookingTime(pickerVal:UIDatePicker) {
        self.bookedDate = pickerVal.date
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard ((txtSource.text?.characters.count)! > 0) && ((txtDestination.text?.characters.count)! > 0) && ((txtNumberOfSeats.text?.characters.count)! > 0) else {
            let alertUser = UIAlertController(title: "Missing Values", message: "Please enter Source, Destination and Number of Seats", preferredStyle: .alert)
            alertUser.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertUser, animated: true, completion: nil)
            return
        }
        
        let vc = segue.destination as! RouteListViewController
        vc.strSource = txtSource.text
        vc.strDestination = txtDestination.text
        vc.iNumberOfSeats = Int(txtNumberOfSeats.text!)
        vc.dtBookingDate = self.bookedDate
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
    }
    
    //MARK: Autocomplete place delegate methods
    public func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Selected Place: \(place.name)")
        
        if currentTag == 10 {
            txtSource.text = place.name
        }
        else if currentTag == 20 {
            txtDestination.text = place.name
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    public func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error while searching place : \(error.localizedDescription)")
        showAlert(title: "Error", message: error.localizedDescription)
        _ = navigationController?.popViewController(animated: true)
    }
    
    public func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Place Selection Cancelled")
        showAlert(title: "Error", message:"Place selection cancelled")
        _ = navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func handleSeatChangeNotification() {
        let alertController = UIAlertController(title: "Ride Booking", message: "Your seats are booked", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
}
