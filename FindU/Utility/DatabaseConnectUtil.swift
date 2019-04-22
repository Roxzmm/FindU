//
//  DatabaseConnectController.swift
//  FindU
//
//  Created by Rochus Xing on 2019/4/21.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit
import OHMySQL
import CoreData

class DatabaseConnectUtil: UIViewController {
    
    //MARK: connect to core data
//    var appDelegate: AppDelegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var coredataContext: NSManagedObjectContext?

//    override init() {
//        coredataContext = appDelegate.persistentContainer.viewContext
////        appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//    }
//    let coredataContext = appDelegate.persistentContainer.viewContext

    //MARK: connect to mysql
    // Initialize coordinator and context
    var coordinator = OHMySQLStoreCoordinator()
    
    let context = OHMySQLQueryContext()
    let dbName = "userDatabase"
    
    // declare used tables
    let tables = ["building": "building", "user": "user", "comment": "comment", "event": "event", "marker": "marker", "facility": "facility"]
//    let buildingTable = "building"
//    let userTable = "user"
//    let commentTable = "comment"
//    let eventTable = "event"
//    let markerTable = "marker"
//    let facilityTable = "facility"
    
    // MySQL Server
    let SQLUserName = "LL"
    let SQLPassword = "group20LL"
    
    let SQLServerName = "findu.cowp9uradhbe.us-east-2.rds.amazonaws.com"
    let SQLServerPort: UInt = 3306
    
    // to do: need to improve access control
    
    func configureMySQL() -> Bool {
        let user = OHMySQLUser(userName: SQLUserName, password: SQLPassword, serverName: SQLServerName, dbName: dbName, port: SQLServerPort, socket: nil)
        coordinator = OHMySQLStoreCoordinator(user: user!)
        coordinator.encoding = .UTF8MB4
        coordinator.connect()
        
        let sqlConnected: Bool = coordinator.isConnected
        if sqlConnected == true {
            print("Connecte successfully")

            context.storeCoordinator = coordinator
            OHMySQLContainer.shared.mainQueryContext = context
        }
        updateLocalData()
        return sqlConnected
    }
    
    // update local core data
    func updateLocalData() {
        coredataContext = appDelegate.persistentContainer.viewContext
//        let coredataContext = appDelegate.persistentContainer.viewContext

        for table in tables {
            let query = OHMySQLQueryRequestFactory.select(table.value, condition: nil)
            if let response = try? context.executeQueryRequestAndFetchResult(query) {
                switch table.value{
                case "building":
                    updateBuilding(response: response)
                case "user":
                    updateUser(response: response)
                case "comment":
                    updateComment(response: response)
                case "event":
                    updateEvent(response: response)
                case "marker":
                    updateMarker(response: response)
                case "facility":
                    updateFacility(response: response)
                default:
                    break;
                }
                
//                for record in response {
//                    let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Building", into: coredataContext!) as! Building
//                    newRecord.name = (record["buildingName"] as! String)
//                    newRecord.buldingID = (record["buildingNo"] as! String)
//                    newRecord.position = (record["position"] as! String)
//                }
            }
        }
        
        do {
            try coredataContext?.save()
            print("Data have been saved in Core data")
        } catch {
            let nserror = error as NSError
//            print("there was an error: " + nserror.localizedDescription)
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func updateBuilding(response: Array<[String: Any?]>) {
//        coredataContext = appDelegate.persistentContainer.viewContext
//        let coredataContext = appDelegate.persistentContainer.viewContext

        for record in response {
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Building", into: coredataContext!) as! Building
            newRecord.name = (record["buildingName"] as! String)
            newRecord.buldingID = (record["buildingNo"] as! String)
            newRecord.position = (record["position"] as! String)
        }
//        do {
//            try coredataContext?.save()
//            print("Data have been saved in Core data")
//        } catch {
//            print("there was an error")
//        }
        
    }
    
    func updateUser(response: Array<[String: Any?]>) {
        for record in response {
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "User", into: coredataContext!) as! User
            newRecord.name = (record["userName"] as! String)
            newRecord.userID = (record["userNo"] as! String)
            newRecord.email = (record["email"] as! String)
            newRecord.credit = (record["credit"] as! Int32)
            newRecord.password = (record["password"] as! String)
        }
    }

    func updateComment(response: Array<[String: Any?]>) {
        for record in response {
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Comment", into: coredataContext!) as! Comment
            newRecord.content = (record["content"] as! String)
            newRecord.commentID = (record["commentNo"] as! String)
        }

    }
    
    func updateEvent(response: Array<[String: Any?]>) {
        for record in response {
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Event", into: coredataContext!) as! Event
            newRecord.name = (record["eventName"] as! String)
            newRecord.eventID = (record["eventNo"] as! String)
            // ... properties waiting to be added
        }

    }
    
    func updateMarker(response: Array<[String: Any?]>) {
        for record in response {
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Marker", into: coredataContext!) as! Marker
            newRecord.markerID = (record["markerNo"] as! String)
            newRecord.buildingName = (record["buildingName"] as! String)
        }

    }
    
    func updateFacility(response: Array<[String: Any?]>) {
        for record in response {
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Facility", into: coredataContext!) as! Facility
            newRecord.name = (record["facilityName"] as! String)
            newRecord.facilityID = (record["facilityNo"] as! String)
            newRecord.position = (record["position"] as! String)
            newRecord.floor = (record["floor"] as! String)
            newRecord.state = (record["state"] as! String)
        }

    }
}
