//
//  InputHandlerUtil.swift
//  FindU
//
//  Created by Rochus Xing on 2019/4/23.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit

class InputHandlerUtil: NSObject {
    
    /*
     * Provide APIs to convert user's input to recognized object
     */
    
    // recognize userId or userEmail
    func checkIdentityType(_ identityInfo: String) -> String{
        var type = "userEmail"
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: identityInfo) == false {
            type = "userID"
        }
        return type
    }

    
}
