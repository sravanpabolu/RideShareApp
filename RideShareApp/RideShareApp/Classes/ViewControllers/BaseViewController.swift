//
//  ViewController.swift
//  RideShareApp
//
//  Created by Sravan on 15/02/17.
//  
//

import UIKit

class BaseViewController: UIViewController {
    
    public func showActivityIndicator() {
        
    }
    
    public func hideActivityIndicator() {
        
    }
    
    public func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

