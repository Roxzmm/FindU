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
    
    let inputHandler = InputHandlerUtil()
    let mysqlConnect = DatabaseConnectUtil()
    let imageHelper = AppImageHelper()
    
//    func testImageHelper() {
//        let photo = UIImage(named: "logo.png")!
//        let resizePhoto = imageHelper.resizeImage(originalImg: photo)
//
//        let noresizeData = imageHelper.compressImageSize(image: photo)
//        let resizeData = imageHelper.compressImageSize(image: resizePhoto)
//
//        let newimage = UIImage(data: noresizeData)
//        print(newimage)
//        let resizeImage = UIImage(data: resizeData)
//
//        XCTAssertNotNil(print("hh"))
//    }
    
    
//    func testSaveImage() {
//        XCTAssert(mysqlConnect.uploadImage(UIImage(named: "event.png")!, filename: "event.png"))
//    }
    
    // never uncomment this test
//    func testuploadDataToMysql() {
//        XCTAssertNotNil(mysqlConnect.updateMySQLBuilding())
//    }

//    func testFetchMarker() {
//        XCTAssertNotNil(mysqlConnect.fetchMarkers())
//    }

//    func testConvertLocation() {
//        XCTAssertNotNil(inputHandler.convertLocation("53°24'10\"N, 2°57'58\"W"))
//    }

//    func testLocation() {
//        let view = SearchFacilityViewController()
//
//        XCTAssertNotNil(view.Arraybylocation())
//    }

    
//    func testCheckPasswordlessthanSix() {
//        XCTAssertFalse(inputHandler.checkPassword("njk"))
//    }
//
//    func testCheckPasswordlargerThanFifteen() {
//        XCTAssertFalse(inputHandler.checkPassword("njksdwfer34efe2e"))
//    }
//
//    func testCheckPasswordNoUpperCase() {
//        XCTAssertFalse(inputHandler.checkPassword("njsdwd32k"))
//    }
//
//    func testCheckPasswordNoNumber() {
//        XCTAssertFalse(inputHandler.checkPassword("njksdwWdef"))
//    }
//
//    func testCheckPasswordtrue() {
//        XCTAssert(inputHandler.checkPassword("Xingrenzhi00"))
//    }
//
//    func testCheckUserName() {
//        XCTAssert(inputHandler.checkUserName("SADAS"))
//    }
//
//    func testCheckUserNameBeyond10Chars() {
//        XCTAssertFalse(inputHandler.checkUserName("SADASsdwadasdwa"))
//    }
//
//    func testCheckEmail() {
//        XCTAssert(inputHandler.checkEmail("asd@asd.com"))
//    }
//
//    func testCheckEmailFalse() {
//        XCTAssertFalse(inputHandler.checkEmail("asd@asd"))
//    }
//
//    //test check userID or email in inputhandler
//    func testCheckIdentityType() {
//        XCTAssert(inputHandler.checkIdentityType("asd@das.com") == "userEmail")
//    }
    
     let tables = ["Building": "Building", "User": "User", "Comment": "Comment", "Event": "Event", "Marker": "Marker", "Facility": "Facility"]
    
//    func testDatabaseConnectUtilSync() {
//        let mysqlConnect = DatabaseConnectUtil()
//
//        XCTAssertNoThrow(mysqlConnect.sync())
//    }
    
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
