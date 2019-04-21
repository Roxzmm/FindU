//
//  DatabaseConnectController.swift
//  FindU
//
//  Created by Rochus Xing on 2019/4/21.
//  Copyright © 2019 Jing. All rights reserved.
//

import Foundation
import OHMySQL

class DatabaseConnectUtil: NSObject {
    
    //MARK: connecnt to mysql
    // Initialize coordinator and context
    var coordinator = OHMySQLStoreCoordinator()
    
    let context = OHMySQLQueryContext()
    let dbName = "findu"
    let tableName = "User"
    
    // MySQL Server
    let SQLUserName = "LL"
    let SQLPassword = "group20LL"
    
    let SQLServerName = "findu.cowp9uradhbe.us-east-2.rds.amazonaws.com"
    let SQLServerPort: UInt = 3306
    
    // to do: need to improve access control
    
    
    coordinator.encoding = .UTF8MB4
    coordinator.connect()
    
    
}
