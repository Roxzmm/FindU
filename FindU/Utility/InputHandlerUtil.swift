//
//  InputHandlerUtil.swift
//  FindU
//
//  Created by Rochus Xing on 2019/4/23.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit
import CoreLocation

class InputHandlerUtil: NSObject {
    
    /*
     * Provide APIs to convert user's input to recognized object
     */
    
    // Convert location to longitude and latitude
    func convertLocation(_ location: String) -> String{
        var newLocation = ""
        var tempDouble: Double
        
        var positions = location.components(separatedBy: ", ")
        var degree: Double
        var minute: Double
        var second: Double
        
        for index in 0..<positions.count {
            let tempdegree = positions[index].components(separatedBy: "°")
            degree = (Double(tempdegree.first!))!
            
            let tempminute = tempdegree.last!.components(separatedBy: "\'")
            minute = (Double(tempminute.first!))!
            
            let tempsecond = tempminute.last!.components(separatedBy: "\"")
            second = (Double(tempsecond.first!))!
            
            minute = minute / 60.0
//            print("minute/60: \(minute)")
            second = second / 3600.0
//            print("second/3600: \(second)")
            tempDouble = degree + minute + second
            positions[index] = String(tempDouble)

            if tempsecond.last == "S" || tempsecond.last == "W" {
                positions[index] = "-" + positions[index]
            }
        }
        newLocation = positions.first! + ", " + positions.last!
//        print(newLocation)
        
        return newLocation
    }
    
    // recognize userId or userEmail
    func checkIdentityType(_ identityInfo: String) -> String{
        var type = "userNo"
        
        if checkEmail(identityInfo) {
            type = "userEmail"
        }
        return type
    }
    
    func checkEmail(_ email: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func checkUserName(_ username: String) -> Bool{
        let count = username.count
        var boolCorrect = false
        
        if count <= 10 && count > 0 {
            boolCorrect = true
        }
        return boolCorrect
    }

    func checkPassword(_ password: String) -> Bool{
        var boolCorrect = false
        
        let count = password.count
        if count >= 6 && count <= 15 {
            if password != password.lowercased() {
                for char in password {
                    if Int(String(char)) != nil {
                        boolCorrect = true
                    }
                }
            }
        }
        return boolCorrect
    }
    
}
