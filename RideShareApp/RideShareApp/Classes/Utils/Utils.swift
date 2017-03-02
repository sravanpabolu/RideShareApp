//
//  Utils.swift
//  RideShareApp
//
//  Created by Sravan on 02/03/17.
//  Copyright © 2017 Tcs. All rights reserved.
//

import Foundation

class Utils: NSObject {
    
    public static var sharedInstance = Utils()
    
    func trimCharacters(sourceString: String) -> String {
        //remove Dot (.)
        var returnString = sourceString.replacingOccurrences(of: ".", with: "")
        
        //remove at (@)
        returnString = returnString.replacingOccurrences(of: "@", with: "")
        
        
        print("returnString :")
        print(returnString)
        
        return returnString
    }
}
