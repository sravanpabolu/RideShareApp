//
//  BookRideViewController.swift
//  RideShareApp
//
//  Created by Sravan on 23/02/17.
//
//

import Foundation
import UIKit

class BookRideViewController: BaseViewController {
    @IBOutlet weak var txtSource: UITextField!
    @IBOutlet weak var txtDestination: UITextField!
    @IBOutlet weak var txtNumberOfSeats: UITextField!
    @IBOutlet weak var pickerBookingDate: UIDatePicker!
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

}
