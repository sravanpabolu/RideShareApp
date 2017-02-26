//
//  SigninViewController.swift
//  RideShareApp
//
//  Created by Sravan on 15/02/17.
//  
//

import Foundation
import GoogleSignIn
import Firebase

class SigninViewController: BaseViewController, GIDSignInUIDelegate {
    
//    @IBOutlet weak var btnSignout: GIDSignInButton!
//    @IBOutlet weak var btnSignin: GIDSignInButton!
    
    @IBOutlet weak var txtFieldIntroduction: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Google Signin
        GIDSignIn.sharedInstance().uiDelegate = self 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //this method is called, after user sign in completes.
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        if let name = User.sharedInstance.userName {
            txtFieldIntroduction.text = "Hello \(name)"
        }
    }
    
//    @IBAction func btnSignoutTapped(_ sender: Any) {
//        GIDSignIn.sharedInstance().disconnect()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
