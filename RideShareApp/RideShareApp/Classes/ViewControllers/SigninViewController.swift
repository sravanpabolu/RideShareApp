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

class SigninViewController: BaseViewController, GIDSignInUIDelegate,GIDSignInDelegate {
    
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
    
    //this method is called, after user sign in completes.
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
//        if let name = User.sharedInstance.userName {
//        //TODO: Should remove the following statement and modify the text in the text view accordingly.
//            txtFieldIntroduction.text = "Hello \(name)"
//        }
//        _ = navigationController?.popToRootViewController(animated: true)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        let userDefaults = UserDefaults.standard
        let formattedEmail = Utils.sharedInstance.trimCharacters(sourceString: user.profile.email!)
        userDefaults.set(formattedEmail, forKey: "User")
        userDefaults.synchronize()

    }

    
//    @IBAction func btnSignoutTapped(_ sender: Any) {
//        GIDSignIn.sharedInstance().disconnect()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
