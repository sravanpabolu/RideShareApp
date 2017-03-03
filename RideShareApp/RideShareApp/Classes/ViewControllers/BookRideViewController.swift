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
    @IBOutlet weak var txtNumberofSeats: UITextField!
    @IBOutlet weak var txtDateTime: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func btnProceedTapped(_ sender: Any) {
        
    }
    
    //MARK: Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
