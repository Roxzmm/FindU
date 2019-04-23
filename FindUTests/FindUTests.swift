//
//  FindUTests.swift
//  FindUTests
//
//  Created by Rochus Xing on 2019/4/21.
//  Copyright © 2019 Jing. All rights reserved.
//

import XCTest
@testable import FindU

class FindUTests: XCTestCase {
    
     let tables = ["Building": "Building", "User": "User", "Comment": "Comment", "Event": "Event", "Marker": "Marker", "Facility": "Facility"]
    
    func testDatabaseConnectUtilSync() {
        let mysqlConnect = DatabaseConnectUtil()
        
        XCTAssertNoThrow(mysqlConnect.sync())
    }
    
//    func testCheckUpdateStatus() {
//        let mysqlConnect = DatabaseConnectUtil()
//
//        XCTAssertNotNil(mysqlConnect.checkUpdateStatus(table: "User"))
//    }
    
//    func testDatabaseConnectUtil() {
//        let mysqlConnect = DatabaseConnectUtil()
//
//        XCTAssert(mysqlConnect.configureMySQL())
//    }

//    override func setUp() {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
