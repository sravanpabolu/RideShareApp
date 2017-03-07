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

class SigninViewController: BaseViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
//    @IBOutlet weak var btnSignout: GIDSignInButton!
//    @IBOutlet weak var btnSignin: GIDSignInButton!
    
    @IBOutlet weak var txtFieldIntroduction: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Google Signin
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // The sign-in flow has finished and was successful if |error| is |nil|.
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // ...
        if let error = error {
            print("Google Signin Error: \(error.localizedDescription)")
            showAlert(title: "Sign In", message: "Sign-in Error: \(error.localizedDescription)")
            return
        }
        
        let userDefaults = UserDefaults.standard
        let formattedEmail = Utils.sharedInstance.trimCharacters(sourceString: user.profile.email!)
        userDefaults.set(formattedEmail, forKey: "User")
        userDefaults.synchronize()
        
        let fullName = user.profile.name
        let email = user.profile.email
        
        print("User : \(fullName) signed in successfully")
        
        let user:User = User.sharedInstance
        user.userName = fullName
        user.userEmail = email
        
        showAlert(title: "Sign In", message: "Sign in Success")
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    //TODO: Logout
    // Finished disconnecting |user| from the app successfully if |error| is |nil|.
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("User : \(user.profile.name) signed out successfully")
    }

    
//    @IBAction func btnSignoutTapped(_ sender: Any) {
//        GIDSignIn.sharedInstance().disconnect()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
