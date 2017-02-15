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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Google Signin
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
