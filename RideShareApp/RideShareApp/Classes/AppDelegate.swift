//
//  AppDelegate.swift
//  RideShareApp
//
//  Created by Sravan on 15/02/17.
//  


import UIKit
import GoogleSignIn
import Firebase
import GooglePlaces
import GoogleMaps
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //For Firebase
        FIRApp.configure()
        
        //For Signin
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //For Google Places
        GMSPlacesClient.provideAPIKey("AIzaSyCR6zbxYZLAstY5NSwUJiQ--kE9Rv8G9FI")
        GMSServices.provideAPIKey("AIzaSyBVcEaLlxvKT_w87TYJ6gmrx2QO-gxrgtM")

        return true
    }

    
    // The sign-in flow has finished and was successful if |error| is |nil|.
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // ...
        if let error = error {
            print("Google Signin Error: \(error.localizedDescription)")
            return
        }
        
//        guard let authentication = user.authentication else { return }
//        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                          accessToken: authentication.accessToken)
//        
//        let userId = user.userID                  // For client-side use only!
//        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
//        let givenName = user.profile.givenName
//        let familyName = user.profile.familyName
//        let email = user.profile.email
        
        print("User : \(fullName) signed in successfully")
    }
    
    
    // Finished disconnecting |user| from the app successfully if |error| is |nil|.
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("User : \(user.profile.name) signed out successfully")
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

