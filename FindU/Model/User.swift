//
//  User.swift
//  FindU
//
//  Created by Rochus Xing on 2019/4/20.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit

class User {
    
    //MARK: Constants
    let initCredit = 80
    let initUserId = ""
    
    //MARK: Properties
    
    var name: String!
    var password: String!
    var email: String?
    var userId: String!
    var credit: Int!
    
    //MARK: Initialization
    
    init(name: String!, password: String!, email: String? = nil) {
        // Initialize stored
        self.name = name
        self.password = password
        self.email = email
        self.userId = initUserId
        self.credit = initCredit
        
        // NO Error checking here, please check input during handling user's input
    }
    
}
