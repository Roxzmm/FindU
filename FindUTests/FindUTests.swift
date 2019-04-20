//
//  FindUTests.swift
//  FindUTests
//
//  Created by Rochus Xing on 2019/4/20.
//  Copyright © 2019 Jing. All rights reserved.
//

import XCTest
@testable import FindU

class FindUTests: XCTestCase {
    
    //MARK: User Class Tests
    
    // Confirm that the User initializer returns an User object when passed valid parameters.
    func testUserInitializationSucceeds() {
        // No email
        let noEmailUser = User.init(name: "noemail_name", password: "a")
        XCTAssertNotNil(noEmailUser)
        
        // With email
        let withEmailUser = User.init(name: "withemail_name", password: "b", email: "11111@qq.com")
        XCTAssertNotNil(withEmailUser)
    }
    

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
