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
    
    let inputHandler = InputHandlerUtil()
    
    //MARK: connect to core data
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var coredataContext: NSManagedObjectContext?

    //MARK: connect to mysql
    // Initialize coordinator and context
    var coordinator = OHMySQLStoreCoordinator()
    let context = OHMySQLQueryContext()
    let db = "userDatabase"
    
    // declare used tables and entities
    let tables = ["Building": "Building", "Marker": "Marker", "Comment": "Comment", "Event": "Event", "Facility": "Facility"]
    let entities = ["Building": Building(), "User": User(), "Comment": Comment(), "Event": Event(), "Marker": Marker(), "Facility": Facility(), "LastUpdateTime": LastUpdateTime()]
//    var entity: EntityExtension

//    let buildingTable = "building"
//    let userTable = "user"
//    let commentTable = "comment"
//    let eventTable = "event"
//    let markerTable = "marker"
//    let facilityTable = "facility"
    
    // MySQL Server
    let SQLAdmName = "LL"
    let SQLAdmPassword = "group20LL"
    
    let SQLRegisteredName = "registered"
    let SQLRegisteredPassword = "group20"
    
    let SQLVisitorName = "visitor"
    let SQLVisitorPassword = "group20"
    
    let SQLServerName = "findu.cowp9uradhbe.us-east-2.rds.amazonaws.com"
    let SQLServerPort: UInt = 3306
    
    static var boolSigned = false
    
    // to do: need to improve access control
    override init() {
        super.init()
        
        coredataContext = appDelegate.persistentContainer.viewContext
    }
    
    // Configure and connect to mysql
    func configureMySQL() -> Bool {
        var SQLUserName = SQLVisitorName
        var SQLPassword = SQLVisitorPassword
        
        // access control
        if DatabaseConnectUtil.boolSigned == true{
            SQLUserName = SQLRegisteredName
            SQLPassword = SQLRegisteredPassword
        }
        
        // delete it after testing
        SQLUserName = SQLAdmName
        SQLPassword = SQLAdmPassword
        
        let user = OHMySQLUser(userName: SQLUserName, password: SQLPassword, serverName: SQLServerName, dbName: db, port: SQLServerPort, socket: nil)
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
    
    func checkConnection() ->Bool{
        var boolConnected = false
        
        if coordinator.isConnected == true {
            boolConnected = true
        }else {
            boolConnected = configureMySQL()
        }
        return boolConnected
    }
    
    // Create new user
    func createNewUser(_ username: String!, _ email: String!, _ password: String!) -> (Bool, userID: String){
        
        // case 0: create fails
        // case 1: create successes
        // case 2: already exist such account(email has been used)
        var boolCreated = false
        var userID = "Sorry, register failed! Please try again."
        
        let tempCondition = "userEmail = " + "\"" + email + "\""

        if checkConnection() == true {
            let query = OHMySQLQueryRequestFactory.select("user", condition: tempCondition)
            if try! context.executeQueryRequestAndFetchResult(query).count != 0 {
                userID = "Sorry, this email has already been used."
                
            }else {
                let anoQuery = OHMySQLQueryRequestFactory.select("user", condition: nil)
                if let response = try? context.executeQueryRequestAndFetchResult(anoQuery) {
                    let userCount = response.count
                    
                    let id = userCount + 1
                    userID = String(id)
                    while userID.count < 3{
                        userID = "0" + userID
                    }
                    userID = "u" + userID
                    
                    let query = OHMySQLQueryRequestFactory.insert("user", set: ["userName": username!, "userEmail": email!, "password": password, "userNo": userID, "userScore": String(80)])
                    do {
                        try? context.execute(query)
                        boolCreated = true
                    }
                }
            }}
        
        return (boolCreated, userID)
    }
    
    // Validate user and authorize user
    func signIn(_ identityType: String = "userEmail", _ identityInfo: String!, _ password: String!, _ auto: Bool = true) -> (Bool, identity: String?) {
        
        var boolValidate = false
        var identity = "Wrong credential! Please check your userID or email and password!"
        
        let userinfo = identityInfo as String
        let tempCondition = identityType + " = " + "\"" + userinfo + "\""
        
        if checkConnection() == true {
            let query = OHMySQLQueryRequestFactory.select("user", condition: tempCondition)
            if let response = try? context.executeQueryRequestAndFetchResult(query) {
                if response.count != 0 {
                    if let userPassword = response[0]["password"] as? String {
                        let username = response[0]["userName"] as! String
                        
                        if userPassword == password {
                            boolValidate = true
                            identity = "Welcome \(username)."
                            
                            // set state = signed globally
                            DatabaseConnectUtil.boolSigned = true
                            
                            if auto == false {
                                let newRecord = NSEntityDescription.insertNewObject(forEntityName: "User", into: coredataContext!) as! User
                                newRecord.name = username
                                newRecord.userID = response[0]["userNo"] as? String
                                newRecord.email = response[0]["userEmail"] as? String
                                newRecord.credit = response[0]["userScore"] as? String
                                newRecord.password = userPassword
                                
                                do {
                                    try coredataContext?.save()
                                } catch {
                                    let nserror = error as NSError
                                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                                }
                            }
                        }else {
                            identity = "Wrong credential! Please check your password!"
                        }
                    }
                }
            }else {
                identity = "Sorry! Sign in fails."
            }
        }
        
        return (boolValidate, identity)
    }
    
    // Sign out and delete user data
    func signOut() -> Bool{
        if let localUser = retrieveLocalUser() {
            coredataContext?.delete(localUser)
            
            // set state = sign out globally
            DatabaseConnectUtil.boolSigned = false
            
            do {
                try coredataContext?.save()
                print("Local user data deleted.")
                
                return true

            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        return false
    }
    
    // Sync core data with mysql (download data from mysql)
    func sync(_ tablesNeedSync: [String]) {
        for table in tablesNeedSync {
            let check = checkUpdateStatus(table: table)
            if check.0 == false {
                if updateTable(table: table) == true {
                    if updateTimeStamp(table: table, responseTime: check.1) == true {
                        print("\(table) syncs successfully.")
                    }
                }
            }
        }
    }
    
    //Connect mysql and check last update time
    func checkUpdateStatus(table: String) -> (Bool, Date) {
        var isUpdated = true
        var responseDate: Date?
        
        if checkConnection() == true {
            //query last update time of specific table
            let query = OHMySQLQueryRequestFactory.select("information_schema.tables", condition: "TABLE_SCHEMA = \"userDatabase\" and TABLE_NAME = \"" + table.lowercased() + "\"", orderBy: ["UPDATE_TIME"], ascending: false)
            if let response = try? context.executeQueryRequestAndFetchResult(query) {
                //            print(response)
                
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
        var count = 1

        for record in response {
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Building", into: coredataContext!) as! Building
            newRecord.name = (record["buildingName"] as! String)
            newRecord.buldingID = (record["buildingNo"] as! String)
            newRecord.position = (record["position"] as! String)
            
            // add a marker for each building
            let newMarker = NSEntityDescription.insertNewObject(forEntityName: "Marker", into: coredataContext!) as! Marker
            newMarker.buildingName = newRecord.name
            newMarker.markerID = String(count)
            newMarker.location = newRecord.position
            count += 1
            
            newRecord.toMarker = newMarker
            newMarker.toBuilding = newRecord
        }
        
    }
    
    func updateUser(response: Array<[String: Any?]>) {
        for record in response {
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "User", into: coredataContext!) as! User
            newRecord.name = (record["userName"] as! String)
            newRecord.userID = (record["userNo"] as! String)
            newRecord.email = (record["userEmail"] as! String)
            newRecord.credit = (record["userScore"] as! String)
            newRecord.password = (record["password"] as! String)
        }
    }

    func updateComment(response: Array<[String: Any?]>) {
        for record in response {
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Comment", into: coredataContext!) as! Comment
            newRecord.content = (record["content"] as! String)
            newRecord.commentID = (record["commentNo"] as! String)
            newRecord.ownerName = (record["ownerName"] as! String)
            newRecord.ownerCredit = (record["ownerCredit"] as! String)
        }

    }
    
    func updateEvent(response: Array<[String: Any?]>) {
        for record in response {
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Event", into: coredataContext!) as! Event
            newRecord.name = (record["eventName"] as! String)
            newRecord.eventID = (record["eventNo"] as! String)
            // ... properties waiting to be added
            newRecord.eventDescription = (record["description"] as! String)
            newRecord.place = (record["eventPlace"] as! String)
            newRecord.hostName = (record["hostName"] as! String)
            newRecord.hostCredit = (record["hostCredit"] as! String)
            newRecord.numOfParticipant = (record["participateSum"] as! String)
            newRecord.date = inputHandler.stringToDate(record["eventDate"] as! String)
            newRecord.membersID = (record["membersNo"] as! String)
            
//            if let photoData = record["poster"] as? Data? {
//                newRecord.poster = photoData
//            }
        }

    }
    
    func updateMarker(response: Array<[String: Any?]>) {
        for record in response {
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Marker", into: coredataContext!) as! Marker
            newRecord.markerID = (record["markerNo"] as! String)
            newRecord.buildingName = (record["buildingName"] as! String)
            newRecord.location = (record["location"] as! String)
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

                let attributeResult = data.value(forKey: attributeType) as? String
                if attributeResult == input {
                    records.append(data)
                }
            }
        
        }catch{
            fatalError("find error")
        }
        
    }
    
    // func to fetch local buildings
    func fetchBuildings() -> [Building]{
        var buildings: [Building] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Building")
        
        do {
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "buldingID", ascending: true)]
            buildings = try coredataContext?.fetch(fetchRequest) as! [Building]
//            for building in buildings {
//                print(marker.location!)
//            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return buildings
    }
    
    // func to fetch local markers
    func fetchMarkers() -> [Marker]{
        var markers: [Marker] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Marker")
        
        do {
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "location", ascending: true)]
            markers = try coredataContext?.fetch(fetchRequest) as! [Marker]
//                        for marker in markers{
//                            print(marker.location!)
//                        }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return markers
    }
    
    // func to fetch local facilities
    func fetchFacilities() -> [Facility]{
        var facilities: [Facility] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Facility")
        
        do {
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "facilityID", ascending: true)]
            facilities = try coredataContext?.fetch(fetchRequest) as! [Facility]
            //                        for marker in markers{
            //                            print(marker.location!)
            //                        }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return facilities
    }
    
    // func to fetch local events
    func fetchEvents(_ condition: String = "date", _ ascending: Bool = false) -> [Event]{
        var events: [Event] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Event")
     
        do {
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: condition, ascending: ascending)]
            events = try coredataContext?.fetch(fetchRequest) as! [Event]
            //                        for marker in markers{
            //                            print(marker.location!)
            //                        }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
 
        return events
    }
    
    // func to fetch local comments
    func fetchComments(_ event: Event) -> [Comment]{
        var comments: [Comment] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Comment")
        
        do {
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "commentID", ascending: true)]
            let tempComments = try coredataContext?.fetch(fetchRequest) as! [Comment]

            var matchId = event.eventID!.dropFirst(4)
            matchId = (matchId.dropLast(3))
            for comment in tempComments {
                var id = comment.commentID!
                if id.removeFirst() == "e" {
                    id = String(id.dropFirst(3))
                    
                    if id == matchId {
                        comments.append(comment)
                    }
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return comments
    }


    
    func retrieveLocalUser() -> User? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        var localUser: User?
        do{
            let result = try coredataContext?.fetch(fetchRequest)
            
            if (result?.count)! > 0 {
                localUser = result?[0] as? User
            }
        } catch {
            print("No stored local user.")
        }
        return localUser
    }
    
//    func deleteObject(_ table:String, _ formatType: String,_ searchType: String,_ input:String) {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: table)
//        let predicate = NSPredicate(format:formatType)
//        fetchRequest.predicate=predicate
//
//        do{
//            let list =  try coredataContext?.execute(fetchRequest) as! [NSManagedObject]
//            for index in 0..<list.count  {
//                if let obj = list[index] as?
//                if obj.searchType==input {
//
//                    coredataContext?.deleteObject(obj)
//                    do{
//
//                        try coradataContext?.save()
//
//                    }catch let error{
//
//                        print("context can't save!, Error:\(error)")
//
//                    }
//                }
//            }
//        }catch{
//            fatalError("find error")
//        }
//    }
    
    
    func addFacility(_ newName:String,_ newFacilityID:String,_ newPosition:String,_ newFloor:String,_ newState:String) {
        
        let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Facility", into: coredataContext!) as! Facility
        newRecord.name = (newName)
        newRecord.facilityID = (newFacilityID)
        newRecord.position = (newPosition)
        newRecord.floor = (newFloor)
        newRecord.state = (newState)
        
    }
    
    func addFMarker(_ markNO:String,_ bulidingNO:String) {
        
        let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Facility", into: coredataContext!) as! Marker
        newRecord.markerID = (markNO)
        newRecord.buildingName = (bulidingNO)
    }
    
    func addUser(_ newName:String,_ newUserID:String,_ newEmail:String,_ newCredit:String,_ newPassword:String) {
        
        let newRecord = NSEntityDescription.insertNewObject(forEntityName: "User", into: coredataContext!) as! User
        newRecord.name = (newName)
        newRecord.userID = (newUserID)
        newRecord.email = (newEmail)
        newRecord.credit = (newCredit)
        newRecord.password = (newPassword)
        
    }
    
    func addEvent(_ attribute: [String: Any]) {
        let record = attribute
        
        let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Event", into: coredataContext!) as! Event
        newRecord.name = (record["eventName"] as! String)
        newRecord.eventID = (record["eventNo"] as! String)
        // ... properties waiting to be added
        newRecord.eventDescription = (record["description"] as! String)
        newRecord.place = (record["eventPlace"] as! String)
        newRecord.hostName = (record["hostName"] as! String)
        newRecord.hostCredit = (record["hostCredit"] as! String)
        newRecord.numOfParticipant = (record["participateSum"] as! String)
        newRecord.date = inputHandler.stringToDate(record["eventDate"] as! String)
        newRecord.membersID = (record["membersNo"] as! String)
        
        if let photoData = record["poster"] as? Data? {
            newRecord.poster = photoData
        }
    }
    
    func addComment(_ content:String,_ commentID:String) {
        
        let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Comment", into: coredataContext!) as! Comment
        newRecord.content = (content)
        newRecord.commentID = (commentID)
        
    }
    
    
    func addBuilding(_ newName:String,_ newBuildingID:String,_ newPosition:String) {
        
        let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Building", into: coredataContext!) as! Building
        newRecord.name = (newName)
        newRecord.buldingID = (newBuildingID)
        newRecord.position = (newPosition)
        
    }
    
    func joinInEvent(_ event: Event) {
        let user = retrieveLocalUser()
        
        if checkConnection() == true {
            var num = event.numOfParticipant!
            num = String(Int(num)! + 1)
            
            var members = event.membersID
            members = members! + ", " + user!.userID!
            
            let query = OHMySQLQueryRequestFactory.update("event", set: ["participateSum": num, "membersNo": members], condition: "eventNo = \(event.eventID)")
            try? context.execute(query)
        }
    }
    
    func uploadEvent(_ eventName: String, _ eventDescription: String, _ location: String, _ time: Date, _ poster: UIImage?) -> Bool {
        var boolUploaded = false
        
        let user = retrieveLocalUser()
        if checkConnection() == true {
            let imageHelper = AppImageHelper()

            let anoQuery = OHMySQLQueryRequestFactory.select("event", condition: nil)
            if let response = try? context.executeQueryRequestAndFetchResult(anoQuery) {
                var eventCount = response.count
                
                eventCount = eventCount + 1
                var eventNo = String(eventCount)
                while eventNo.count < 3 {
                    eventNo = "0" + eventNo
                }
                eventNo = "e" + eventNo
                
                let members = user?.userID
                
                var set = ["eventName": eventName, "description": eventDescription, "eventPlace": location, "eventNo": eventNo, "hostCredit": user!.credit!, "hostName": user!.name, "eventDate": time, "participateSum": String(1), "membersNo": members] as [String : Any]
                if poster != nil {
                    let originalData = poster?.pngData()
                    set = ["eventName": eventName, "description": eventDescription, "eventPlace": location, "eventNo": eventNo, "hostCredit": user!.credit!, "hostName": user!.name, "eventDate": time, "participateSum": String(1), "membersNo": members, "poster": originalData]
                    
                    addEvent(set)
//                    let resizeImage = imageHelper.resizeImage(originalImg: poster!) as UIImage
//                    let posterData = imageHelper.compressImageSize(image: resizeImage)
//                    set = set + ["posetr": posterData]
                }
                
                let query = OHMySQLQueryRequestFactory.insert("event", set: set as [String : Any])
                    
                try? context.execute(query)
                boolUploaded = true
                
            }
        }
        return boolUploaded
    }
    
    func uploadComment(_ matchID: String, _ content: String, _ facilityNo: String) -> Bool {
        var boolUploaded = false
        
        let user = retrieveLocalUser()
        if checkConnection() == true {
            let ownerCredit = user?.credit!
            let ownerName = user?.name!
            
            let anoQuery = OHMySQLQueryRequestFactory.select("event", condition: nil)
            if let response = try? context.executeQueryRequestAndFetchResult(anoQuery) {
                var commentCount = response.count
                
                commentCount = commentCount + 1
                var commentNo = String(commentCount)
                commentNo = matchID + commentNo + facilityNo
                
                let query = OHMySQLQueryRequestFactory.insert("comment", set: ["content": content, "commentNo": commentNo, "ownerName": ownerName, "ownerCredit": ownerCredit])
                
                try? context.execute(query)
                boolUploaded = true
                
            }
        }
        return boolUploaded
    }
    
    // update user info from mysql
    func updateUserInfo() {
        if let localUser = retrieveLocalUser() {
            
            let email = localUser.email!
            let query = OHMySQLQueryRequestFactory.select("user", condition: "userEmail = \"\(email)\"")
            if let response = try? context.executeQueryRequestAndFetchResult(query) {
                
                if response.count == 1 {
                    let record = response[0]
                    localUser.setValue(record["userNo"], forKey: "userID")
                    localUser.setValue(record["userName"], forKey: "name")
                    localUser.setValue(record["userEmail"], forKey: "email")
                    localUser.setValue(record["password"], forKey: "password")
                    localUser.setValue(record["userScore"], forKey: "credit")
                    
                    if let photoData = record["userPhoto"] as? Data? {
                        print("userPhoto is up to date")
                        localUser.setValue(photoData, forKey: "userPhoto")
                    }
                }
                
                do {
                    try coredataContext?.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    // upload user photo to mysql
    func uploadUserPhoto(_ image: UIImage) {
        if checkConnection() == true {
            if let localUser = retrieveLocalUser() {
                
                let imageHelper = AppImageHelper()
                
                let id = localUser.userID!
//                let photoData = image.pngData()
                let resizeImage = imageHelper.resizeImage(originalImg: image)
                let compressedData = imageHelper.compressImageSize(image: resizeImage)
                
                localUser.userPhoto = compressedData
                print(compressedData)
            
                let query = OHMySQLQueryRequestFactory.update("user", set: ["userPhoto": compressedData], condition: "userNo = \(id)")
                try? context.execute(query)
                
                do {
                    try coredataContext?.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    func deleteEevent(_ condition:String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Evnet")
        fetchRequest.predicate = NSPredicate(format: condition)
        
        do{
            let eventList = try coredataContext?.fetch(fetchRequest)
            for index in 0..<eventList!.count{
                let event = eventList?[index] as! Event
                coredataContext?.delete(event)
                try coredataContext?.save()
            }
        }catch let error{
            print("context can't save!, Error:\(error)")
        }
    }
    
    
    func deleteUser(_ condition:String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: condition)
        
        do{
            let userList = try coredataContext?.fetch(fetchRequest)
            for index in 0..<userList!.count{
                let user = userList?[index] as! User
                coredataContext?.delete(user)
                try coredataContext?.save()
            }
        }catch let error{
            print("context can't save!, Error:\(error)")
        }
    }
    
    func deleteMarker(_ condition:String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Marker")
        fetchRequest.predicate = NSPredicate(format: condition)
        
        do{
            let markerList = try coredataContext?.fetch(fetchRequest)
            for index in 0..<markerList!.count{
                let marker = markerList?[index] as! Marker
                coredataContext?.delete(marker)
                try coredataContext?.save()
            }
        }catch let error{
            print("context can't save!, Error:\(error)")
        }
    }
    
    func deleteComment(_ condition:String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Comment")
        fetchRequest.predicate = NSPredicate(format: condition)
        
        do{
            let commentList = try coredataContext?.fetch(fetchRequest)
            for index in 0..<commentList!.count {
                let comment = commentList?[index] as! Comment
                coredataContext?.delete(comment)
                try coredataContext?.save()
            }
        }catch let error{
            print("context can't save!, Error:\(error)")
        }
    }
    
    func deleteFacility(_ condition:String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Facility")
        fetchRequest.predicate = NSPredicate(format: condition)
        
        do{
            let facilityList = try coredataContext?.fetch(fetchRequest)
            for index in 0..<facilityList!.count{
                let facility = facilityList?[index] as! Facility
                coredataContext?.delete(facility)
                try coredataContext?.save()
            }
        }catch let error{
            print("context can't save!, Error:\(error)")
        }
    }
    
    
    func updateEvent(_ condition:String,_ newName:String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        fetchRequest.predicate = NSPredicate(format: condition)
        
        do{
            let eventList = try coredataContext?.fetch(fetchRequest)
            for index in 0..<eventList!.count{
                let event = eventList?[index] as! Event
                event.name = newName
                try coredataContext?.save()
            }
        }catch let error{
            print("context can't save!, Error:\(error)")
        }
    }
    
    func updateComment(_ condition:String,_ newContent:String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Comment")
        fetchRequest.predicate = NSPredicate(format: condition)
        
        do{
            let commentList = try coredataContext?.fetch(fetchRequest)
            for index in 0..<commentList!.count {
                let comment = commentList?[index] as! Comment
                comment.content = newContent
                try coredataContext?.save()
            }
        }catch let error{
            print("context can't save!, Error:\(error)")
        }
    }
    
    func updateMarker(_ condition:String,_ newBuildingNO:String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Marker")
        fetchRequest.predicate = NSPredicate(format: condition)
        
        do{
            let markerList = try coredataContext?.fetch(fetchRequest)
            for index in 0..<markerList!.count{
                let marker = markerList?[index] as! Marker
                marker.buildingName = newBuildingNO
                try coredataContext?.save()
            }
        }catch let error{
            print("context can't save!, Error:\(error)")
        }
    }
    
    func updateFacility(_ condition:String,_ newName:String,_ newPosition:String,_ newFloor:String,_ newState:String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Facility")
        fetchRequest.predicate = NSPredicate(format: condition)
        do{
            let facilityList = try coredataContext?.fetch(fetchRequest)
            for index in 0..<facilityList!.count{
                let facility = facilityList?[index] as! Facility
                facility.name = newName
                facility.position = newPosition
                facility.floor = newFloor
                facility.state = newState
                try coredataContext?.save()
            }
        }catch let error{
            print("context can't save!, Error:\(error)")
        }
    }
    
    //MARK: func to upload data to mysql (be careful)!!!
    
    func deleteMySQLRecord(_ table: String, _ condition: String?) {
        if checkConnection() == true {
            let query = OHMySQLQueryRequestFactory.delete(table, condition: condition)
            try? context.execute(query)
        }
    }
    
    func addRecordToMySQL(_ table: String, _ attribute: [String: Any?]) {
        if checkConnection() == true {
            let query = OHMySQLQueryRequestFactory.insert(table, set: attribute as [String : Any])
            try? context.execute(query)
        }
    }
    
    // for saving database
    // comment this function after using
//    func updateMySQLBuilding() {
//        deleteMySQLRecord("building", nil)
//        deleteMySQLRecord("marker", nil)
//        let inputHandler = InputHandlerUtil()
//
//        let buildings = fetchBuildings()
//        let markers = fetchMarkers()
//        //
//        let users = retrieveLocalUser()
//        let facilities = fetchFacilities()
//        let events = fetchEvents()
//
//        if checkConnection() == true {
//            for building in buildings{
//                let id = (building.buldingID! as String?)!
//                let name = (building.name as String?)!
//                //            var position = ""
//                //            if marker.location?.count != 0 {
//                //                position = (marker.location as String?)!
//                //            }
//                let position = (building.position as String?)!
//                var temp = ""
//                if position.count != 0 {
//                    temp = inputHandler.convertLocation(position)
//                }
//                let attribute = ["buildingNo": id, "position": temp, "buildingName": name]
//                print(attribute)
//
//                let query = OHMySQLQueryRequestFactory.insert("building", set: attribute)
//                try? context.execute(query)
//
//            }
//
//            for marker in markers{
//                let id = (marker.markerID! as String?)!
//                let name = (marker.buildingName as String?)!
//                //            var position = ""
//                //            if marker.location?.count != 0 {
//                //                position = (marker.location as String?)!
//                //            }
//                let position = (marker.location as String?)!
//                var temp = ""
//                if position.count != 0 {
//                    temp = inputHandler.convertLocation(position)
//                }
//                let attribute = ["markerNo": id, "location": temp, "buildingName": name]
//                print(attribute)
//
//                let query = OHMySQLQueryRequestFactory.insert("marker", set: attribute)
//                try? context.execute(query)
//            }
            
            
//                let id = (user.userID! as String?)!
//                let name = (user.name as String?)!
//                //            var position = ""
//                //            if marker.location?.count != 0 {
//                //                position = (marker.location as String?)!
//                //            }
//                let position = (building.position as String?)!
//                var temp = ""
//
//                let attribute = ["buildingNo": id, "position": temp, "buildingName": name]
//                print(attribute)
//
//                let query = OHMySQLQueryRequestFactory.insert("user", set: attribute)
//                try? context.execute(query)
            
          
         
//            for facility in facilities{
//                let id = (facility.facilityID as String?)!
//                let name = (facility.name as String?)!
//                let state = (facility.state as String?)!
//                let floor = (facility.floor as String?)!
//                //            var position = ""
//                //            if marker.location?.count != 0 {
//                //                position = (marker.location as String?)!
//                //            }
//                let position = (facility.position as String?)!
//                var temp = ""
//                if position.count != 0 {
//                    temp = inputHandler.convertLocation(position)
//                }
         
//                if name.contains("'"){
//                    print(name)
//                    let temp = name.replacingOccurrences(of: "'", with: "")
//                    print(temp)
//
//
//                    let attribute = ["facilityNo": id, "position": position, "facilityName": temp, "state": state, "floor": floor]
//                    print(attribute)
//
//                    let query = OHMySQLQueryRequestFactory.insert("facility", set: attribute)
//                    try? context.execute(query)
//                }
//            }
//            for event in events{
//                let id = (event.eventID! as String?)!
//                let name = (event.name as String?)!
//
//                //            var position = ""
//                //            if marker.location?.count != 0 {
//                //                position = (marker.location as String?)!
//                //            }
//
//                let hostName = (event.name as String?)!
//                let hostCredit = (event.name as String?)!
//                let eventDate = (event.name as String?)!
//                let eventPlace = (event.name as String?)!
//                let participat = (event.name as String?)!
//
//                let attribute = ["eventNo": id, "eventName": name]
//                print(attribute)
//
//                let query = OHMySQLQueryRequestFactory.insert("event", set: attribute)
//                try? context.execute(query)
//
//            }
//        }
//    }
}
