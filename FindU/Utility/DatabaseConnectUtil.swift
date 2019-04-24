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
    
    /*
     * Provide APIs to handle kinds of problems need connecting to database
     */
    
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
//    var entity: EntityExtension

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
        }
        return sqlConnected
    }
    
    // Create new user
    func createNewUser(_ username: String!, _ email: String!, _ password: String!) -> (Bool, userID: String?){
        
        var boolCreated = false
        var userID = "Sorry, register failed! Please try again."
        
        
        return (boolCreated, userID)
    }
    
    // Validate user and authorize user
    func validateUser(_ identity: String!, _ password: String!) -> (Bool, errorIdentity: String?) {
        
        var boolValidate = false
        var errorIdentity = "Wrong credential! Please check your user identity and password!"
        
        
        
        
        return (boolValidate, errorIdentity)
    }
    
    // Sync core data with mysql
    func sync() {
        for table in tables {
            let check = checkUpdateStatus(table: table.value)
            if check.0 == false {
                if updateTable(table: table.value) == true {
                    updateTimeStamp(table: table.value, responseTime: check.1)
                }
            }
        }
    }
    
    //Connect mysql and check last update time
    func checkUpdateStatus(table: String) -> (Bool, Date) {
        var isUpdated = true
        var responseDate: Date?
        
        //query last update time of specific table
        let query = OHMySQLQueryRequestFactory.select("information_schema.tables", condition: "TABLE_SCHEMA = \"userDatabase\" and TABLE_NAME = \"" + table.lowercased() + "\"", orderBy: ["UPDATE_TIME"], ascending: false)
        if let response = try? context.executeQueryRequestAndFetchResult(query) {
            print(response)

            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            

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
        return (isUpdated, responseDate!)
    }
    
    // Initialize or retrieve last update time of specific table stored locally
    func retrieveLastUpdateTime(tableName: String) -> Date {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LastUpdateTime")

        var lastUpdateTime: Date = Date.distantPast
//        fetchRequest.fetchLimit = 1
//        fetchRequest.returnsObjectsAsFaults = false
        do{
            let result = try coredataContext?.fetch(fetchRequest)

            if result?.count == 0 {
                let newTime = NSEntityDescription.insertNewObject(forEntityName: "LastUpdateTime", into: coredataContext!) as! LastUpdateTime
                newTime.setValue(Date.distantPast, forKey: tableName.lowercased())
                
                // store the new update record
                do {
                    try coredataContext?.save()
                    print("lastUpdateTime initializes successfully!")
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
    
    // update lastUpdateTime for each table
    func updateTimeStamp(table: String, responseTime: Date) -> Bool{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LastUpdateTime")
        var boolTimeStamp = false
        
        do{
            let result = try coredataContext?.fetch(fetchRequest)
            
            let timestampUpdate = result![0] as! NSManagedObject
            timestampUpdate.setValue(responseTime, forKey: table.lowercased())
            
            do {
                try coredataContext?.save()
                boolTimeStamp = true
                print(table + " lastUpdateTime updates successfully!")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
        }catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return boolTimeStamp
    }
    
    // update table based on existed local data
    func updateTable(table: String) -> Bool{
        let boolDelete = deleteTable(table: table)
        let boolDownload = downloadTable(table: table)
        return boolDelete && boolDownload
    }
    
    // delete a full table stored in local database
    func deleteTable(table: String) -> Bool{
        let fetchReuest = NSFetchRequest<NSFetchRequestResult>(entityName: table)
        
        var boolDelete = false
        do {
            let result = try coredataContext?.fetch(fetchReuest)

            for index in 0..<result!.count {
                let objectToDelte = result![index] as! NSManagedObject
                coredataContext?.delete(objectToDelte)
            }
            
            do {
                try coredataContext?.save()
                boolDelete = true
                print(table + " Data in Core Data have been deleted!")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return boolDelete
    }
    
    // download a full table from mysql
    func downloadTable(table: String) -> Bool{
        let query = OHMySQLQueryRequestFactory.select(table.lowercased(), condition: nil)
        var boolDownload = false
        
        if let response = try? context.executeQueryRequestAndFetchResult(query) {
            switch table.lowercased(){
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
        
        do {
            try coredataContext?.save()
            boolDownload = true
            print(table + " Data have been saved in Core data!")
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return boolDownload
    }
    
    // first time download local core data
    func initLocalData() {
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
            print("local data initializes successfully!")
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
    
//    func findBuilding(_ sender: Any) {
//        //查询请求
//        let request:NSFetchRequest = Building.fetchRequest()
//        //这里可以加入查询的条件
//
//        do{
//            let result =  try coredataContext?.fetch(request)
//        }catch{
//            fatalError("find error")
//        }
//    }
//
//    func findEvent(_ sender: Any) {
//        //查询请求
//        let request:NSFetchRequest = Event.fetchRequest()
//        //这里可以加入查询的条件
//
//        do{
//            let result =  try coredataContext?.fetch(request)
//        }catch{
//            fatalError("find error")
//        }
//    }
//
//    func findFacility(_ sender: Any) {
//        //查询请求
//        let request:NSFetchRequest = Facility.fetchRequest()
//        //这里可以加入查询的条件
//
//        do{
//            let result =  try coredataContext?.fetch(request)
//        }catch{
//            fatalError("find error")
//        }
//    }
    
    func findObject(_ table:String, _ attributeType: String, _ input:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: table)
        var records: [Any] = []
        do{
            let result =  try coredataContext?.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
//                entity = EntityExtension(attributeType)

                var attributeResult = data.value(forKey: attributeType) as? String
                if attributeResult == input {
                    records.append(data)
                }
            }
        
        }catch{
            fatalError("find error")
        }
        
    }
    
    
    func deleteEevent(_ sender: Any) {
        
    }
}
