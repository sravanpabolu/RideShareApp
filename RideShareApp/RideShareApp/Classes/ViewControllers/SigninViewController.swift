//
//  SigninViewController.swift
//  RideShareApp
//
//  Created by Sravan on 15/02/17.
//  Copyright © 2017 Tcs. All rights reserved.
//

import Foundation
import GoogleSignIn
import Firebase

class SigninViewController: BaseViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var btnSignout: GIDSignInButton!
    @IBOutlet weak var btnSignin: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Google Signin
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
    }
    
    @IBAction func btnSigninTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func btnSignoutTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().disconnect()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
