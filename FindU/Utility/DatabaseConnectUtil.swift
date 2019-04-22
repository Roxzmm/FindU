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

class DatabaseConnectUtil: NSObject {
    
    //MARK: connect to core data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var coredataContext: NSManagedObjectContext?

    //MARK: connect to mysql
    // Initialize coordinator and context
    var coordinator = OHMySQLStoreCoordinator()
    
    let context = OHMySQLQueryContext()
    let dbUser = "userDatabase"
    
    // declare used tables and entities
    let tables = ["Building": "Building", "User": "User", "Comment": "Comment", "Event": "Event", "Marker": "Marker", "Facility": "Facility"]
//    let entities = ["Building": Building(), "User": User(), "Comment": Comment(), "Event": Event(), "Marker": Marker(), "Facility": Facility(), "LastUpdateTime": LastUpdateTime()]

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
    override init() {
        super.init()
        
        coredataContext = appDelegate.persistentContainer.viewContext
        self.configureMySQL(dbName: dbUser)
    }
    
    // Configure and connect to mysql
    func configureMySQL(dbName: String) -> Bool {
        let user = OHMySQLUser(userName: SQLUserName, password: SQLPassword, serverName: SQLServerName, dbName: dbName, port: SQLServerPort, socket: nil)
        coordinator = OHMySQLStoreCoordinator(user: user!)
        coordinator.encoding = .UTF8MB4
        
        coordinator.connect()
        
        let sqlConnected: Bool = coordinator.isConnected
        if sqlConnected == true {
            print("Connecte successfully")

            context.storeCoordinator = coordinator
            OHMySQLContainer.shared.mainQueryContext = context

//            updateLocalData()
        }
        return sqlConnected
    }
    
    //Connect mysql and check last update time
    func checkUpdateStatus(table: String) -> Bool {
        var isUpdated = true
        
        //query last update time of specific table
        let query = OHMySQLQueryRequestFactory.select("information_schema.tables", condition: "TABLE_SCHEMA = \"userDatabase\" and TABLE_NAME = \"" + table.lowercased() + "\"", orderBy: ["UPDATE_TIME"], ascending: false)
        if let response = try? context.executeQueryRequestAndFetchResult(query) {
            print(response)

            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            var responseDate: Date?
            if let stringDate = response[0]["UPDATE_TIME"] as? String {
                responseDate = dateFormatter.date(from: stringDate)
            }else {
                responseDate = Date.distantPast
            }
            print(responseDate!)
            let retrieveDate = retrieveLastUpdateTime(tableName: table)
            print(retrieveDate)
            
            if responseDate != retrieveDate {
                isUpdated = false
            }
        }

        print(isUpdated)
        return isUpdated
    }
    
    // Retrieve last update time of specific table stored locally
    func retrieveLastUpdateTime(tableName: String) -> Date {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LastUpdateTime")
        
//        coredataContext = appDelegate.persistentContainer.viewContext

        var lastUpdateTime: Date = Date.distantPast
//        fetchRequest.fetchLimit = 1
//        fetchRequest.returnsObjectsAsFaults = false
        do{
            let result = try coredataContext?.fetch(fetchRequest)
//            for data in result as! [NSManagedObject] {
//                lastUpdateTime = data.value(forKey: tableName.lowercased()) as? Date
//                print(lastUpdateTime as Any)
//            }
            if result?.count == 0 {
                let newTime = NSEntityDescription.insertNewObject(forEntityName: "LastUpdateTime", into: coredataContext!) as! LastUpdateTime
                newTime.setValue(Date.distantPast, forKey: tableName.lowercased())
                
                // store the new update record
                do {
                    try coredataContext?.save()
                    print("Data have been saved in Core data")
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }else {
                for data in result as! [NSManagedObject] {
                    if let templastUpdateTime = data.value(forKey: tableName.lowercased()) as? Date {
                        lastUpdateTime = templastUpdateTime
                    }
                }
            }
        } catch {
            print("fetch failed")
        }
        return lastUpdateTime
    }
    
    // update local core data
    func updateLocalData() {
//        coredataContext = appDelegate.persistentContainer.viewContext
//        let coredataContext = appDelegate.persistentContainer.viewContext

        for table in tables {
            let query = OHMySQLQueryRequestFactory.select(table.value.lowercased(), condition: nil)
            if let response = try? context.executeQueryRequestAndFetchResult(query) {
                switch table.value.lowercased(){
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
            }
        }
        
        do {
            try coredataContext?.save()
            print("Data have been saved in Core data")
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func updateBuilding(response: Array<[String: Any?]>) {

        for record in response {
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Building", into: coredataContext!) as! Building
            newRecord.name = (record["buildingName"] as! String)
            newRecord.buldingID = (record["buildingNo"] as! String)
            newRecord.position = (record["position"] as! String)
        }
        
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
