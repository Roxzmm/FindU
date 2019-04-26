//
//  SearchFacilityViewController.swift
//  FindU
//
//  Created by 张景 on 2019/3/27.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SearchFacilityViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var inputStartPosition: UITextField!
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var InputFacility: UITextField!
   
    @IBAction func SearchBtn(_ sender: Any) {
        
    }
    
    @IBOutlet weak var bottomBar: UITabBar!
    @IBOutlet weak var EventBarItem: UITabBarItem!
    
    var locationManager = CLLocationManager()
    
    var markers: [Marker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Search")
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        /*
         * fetch markers
         * attributes of marker: markerID, builgdingName, location  (all are string)
         * location's example output: 53°24'5"N, 2°57'50"W
         */
        let mysqldatabaseUtil = DatabaseConnectUtil()
        markers = mysqldatabaseUtil.fetchMarkers()
//        Arraybylocation()
        
        
//        setpicture()

        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locationOfUser = locations[0]
        
        //            userLoc = locations[0]
        let latitude = locationOfUser.coordinate.latitude
        let longitude = locationOfUser.coordinate.longitude
        let latDelta: CLLocationDegrees = 0.0005
        let lonDelta: CLLocationDegrees = 0.0005
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
        
        //            Arraybylocation()
    }
    
//    func setpicture(){
//        EventBarItem.image = UIImage(contentsOfFile: "eventLogo")
//        EventBarItem.selectedImage =  UIImage(contentsOfFile: "eventLogo")?.withRenderingMode(.alwaysOriginal)
    
//    func Arraybylocation(){
//
//        for i in 0...markers.count-1{
//            let lat = markers[i].lat
//            let latitude = Double(lat!)
//            let lon = markers[i].long
//            let longitude = Double(lon!)
//
//            //                let a = latitude!
//            //                let b
//            let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinate
//            annotation.title = markers[i].location //显示什么？
//            self.map.addAnnotation(annotation)
//
//        }
//
//
//        var locationlist : [String] = []
//        //            var locationNoteList: [String] = []
//        var distance : [Double] = []
//        var locationAndDistance: [String : Double] = [String : Double]()
//        var finalLocationlist : [String] = []
//
//        //         var locationlist : [String] = []
//        var lat : [Double] = []
//        var long : [Double] = []
//
//
//
//        var howManyArtWorksInLocation : [Int] = []
//        var startlocation = markers[0].location!
//        //            var startlocationNote = markers[0].locationNotes!
//        let startlocationLat = (Double)(markers[0].lat!)!
//        let startlocationLong = (Double)(markers[0].long!)!
//        //         var distance : [Double] = []
//        var a = 0
//        var b = 0
//
//        locationlist.append(startlocation)
//        //            locationNoteList.append(startlocationNote)
//        lat.append(startlocationLat)
//        long.append(startlocationLong)
//        for aArt in markers{
//
//            if aArt.location! == startlocation{
//                b = b+1
//            }
//            else{
//                howManyArtWorksInLocation.append(b)
//                b = 1
//                startlocation = aArt.location!
//                locationlist.append(aArt.location!)
//                lat.append((Double)(aArt.lat!)!)
//                long.append((Double)(aArt.long!)!)
//
//
//            }
//            a = a+1
//        }
//        howManyArtWorksInLocation.append(b)
//
//        for i in 0...locationlist.count-1{
//
//            let artLcLocation = CLLocation(latitude:CLLocationDegrees(lat[i]), longitude: CLLocationDegrees(long[i]))
//            //            print(userLoc!)
//
//            let artToUser = artLcLocation.distance(from: userLoc)
//            distance.append(artToUser)
//        }
//
//
//        for i in 0...distance.count-1{
//            //            print("\(locationlist[i]) : \(distance[i])")
//            locationAndDistance[locationlist[i]] = distance[i]
//        }
//
//
//        let result4 = locationAndDistance.sorted { (str1, str2) -> Bool in
//            return str1.1 < str2.1
//        }
//
//        for key in 0...result4.count-1{
//            finalLocationlist.append(result4[key].key)
//        }
//        self.locationBydistance = finalLocationlist
//
//        for i in 0..<finalLocationlist.count{
//            var eachLocation: [ArtworkInformation] = []
//            for aArt in self.markers{
//                if aArt.location! == finalLocationlist[i]  {
//                    eachLocation.append(aArt)
//                }
//            }
//            self.sectionByLocation[finalLocationlist[i]] = eachLocation
//        }
//        //        for i in 0...finalLocationlist.count-1{
//        //            print(finalLocationlist[i])
//        //        }
//        //        print(result4)
//        //        for a in locationlist{
//        //            distance = userLoc.distance(from: a)
//        //                    }
//
//    }

    

// mapView
    
//    import UIKit
//    import MapKit
//    import CoreLocation
//    import CoreData
//
//    class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate{
//
//
//
//        var locationManager = CLLocationManager()
//
//        let userLoc = CLLocation(latitude:CLLocationDegrees(53.406566), longitude: CLLocationDegrees(-2.966531))
//
//        var locationBydistance : [String] = []
//        var titleN = ""
//        var artistN = ""
//        var yearOfWorkN = ""
//        var informationN = ""
//
//        @IBOutlet weak var map: MKMapView!
//
//        @IBOutlet weak var table: UITableView!
//
//
//
//
//        var markers: [ArtworkInformation] = []
//        var sectionByLocation : [String : [ArtworkInformation]] = [:]
//
//
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//
//
//            locationManager.delegate = self as CLLocationManagerDelegate
//            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//            locationManager.requestWhenInUseAuthorization()
//            locationManager.startUpdatingLocation()
//
//
//            //第一次启动
//            if (!(UserDefaults.standard.bool(forKey: "everLaunched"))) {
//                UserDefaults.standard.set(true, forKey:"everLaunched")
//                let firstOpenViewController = FirstOpenViewController()
//                firstOpenViewController.jsonSave()
//
//                let date = Date()
//                let formatter = DateFormatter()
//                formatter.dateFormat = "yyyy-MM-dd"
//                let todayString = formatter.string(from: date)
//                UserDefaults.standard.set(todayString, forKey: "todayStringKey")
//
//
//
//
//            }
//            else{
//                //除第一次登陆以外的情况
//
//                jsonSave()
//                fetchInf()
//                Arraybylocation()
//                self.table.reloadData()
//
//                //            let RetrivedDate = UserDefaults.standard.object(forKey: "todayStringKey") as? String
//                //            print(RetrivedDate)
//            }
//            //
//            //         table.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
//        }
//
//        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//            let lable = UILabel()
//            lable.text = locationBydistance[section]
//            lable.backgroundColor = UIColor.lightGray
//            return lable
//
//        }
//
//        func numberOfSections(in tableView: UITableView) -> Int {
//            return locationBydistance.count
//        }
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return sectionByLocation[locationBydistance[section]]!.count
//        }
//
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "myCell")
//            let title = sectionByLocation[locationBydistance[indexPath.section]]![indexPath.row].title
//            let author = sectionByLocation[locationBydistance[indexPath.section]]![indexPath.row].artist
//
//            cell.textLabel?.text = title
//            cell.detailTextLabel?.text = author
//            return cell
//        }
//
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//            tableView.deselectRow(at: indexPath, animated: true)
//
//
//            titleN = sectionByLocation[locationBydistance[indexPath.section]]![indexPath.row].title!
//            artistN = sectionByLocation[locationBydistance[indexPath.section]]![indexPath.row].artist!
//            informationN = sectionByLocation[locationBydistance[indexPath.section]]![indexPath.row].information!
//            yearOfWorkN = sectionByLocation[locationBydistance[indexPath.section]]![indexPath.row].yearOfWork!
//
//
//            performSegue(withIdentifier: "showDetail", sender: self)
//
//
//        }
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            let des = segue.destination as! detailView
//            des.titleName = titleN
//            des.artistName =  artistN
//            des.informationName = informationN
//            des.yearOfWorkName =  yearOfWorkN
//
//            //        favourite = des.returnFavourite()
//            //        updateFavourite(title: titleN,favourite: favourite)
//
//
//        }
//
//
//
//
//        override func viewWillAppear(_ animated: Bool) {
//        }
//
//        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//            let locationOfUser = locations[0]
//
//            //            userLoc = locations[0]
//            let latitude = locationOfUser.coordinate.latitude
//            let longitude = locationOfUser.coordinate.longitude
//            let latDelta: CLLocationDegrees = 0.0005
//            let lonDelta: CLLocationDegrees = 0.0005
//            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
//            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//            let region = MKCoordinateRegion(center: location, span: span)
//            self.map.setRegion(region, animated: true)
//
//            //            Arraybylocation()
//        }
//
//
//        func jsonSave(){
//            struct artInfor: Decodable {
//
//                let id: String?
//                let title: String?
//                let artist: String?
//                let yearOfWork: String?
//                let information: String?
//                let lat: String?
//                let long: String?
//                let location: String?
//                let locationNotes: String?
//                let fileName: String?
//                let lastModified: String?
//                let enabled: String?
//
//            }
//
//            struct artInformation: Decodable {
//                let campus_artworks: [artInfor]
//            }
//            let RetrivedDate = UserDefaults.standard.object(forKey: "todayStringKey") as? String
//
//
//
//            if let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/artworksOnCampus/data.php?class=campus_artworks&lastUpdate=\(RetrivedDate!)"){
//                //2019-02-20
//                let session = URLSession.shared
//
//                //if 没有更新
//                session.dataTask(with:url) { (data, response, err) in
//
//                    guard let jsonData = data else {
//                        return }
//
//                    do{
//                        let decoder = JSONDecoder()
//                        let artList = try decoder.decode(artInformation.self, from: jsonData)
//
//                        //                    if self.markers.count != artList.artInfor2.count{
//                        for OInfor in self.markers{
//                            for aInfor in artList.campus_artworks {
//                                if OInfor.id == aInfor.id{
//                                    DispatchQueue.main.async {
//                                        self.update(id: OInfor.id,title:OInfor.title,artist: OInfor.artist,yearOfWork: OInfor.yearOfWork,information: OInfor.information,lat: OInfor.lat,long: OInfor.long,location: OInfor.location,locationNotes: OInfor.locationNotes,fileName: OInfor.fileName,lastmodified:OInfor.lastModified,enabled:OInfor.enabled )
//                                        print("update:\(OInfor.id!)")
//                                        self.fetchInf()
//                                        self.table.reloadData()
//                                    }
//                                }
//                                else{
//
//                                    var count = 0
//                                    for TInfor in self.markers{
//                                        if TInfor.id != aInfor.id{
//                                            count = count + 1
//                                        }
//                                    }
//                                    if count == self.markers.count{
//                                        DispatchQueue.main.async {
//                                            self.save(id: aInfor.id,title:aInfor.title,artist: aInfor.artist,yearOfWork: aInfor.yearOfWork,information: aInfor.information,lat: aInfor.lat,long: aInfor.long,location: aInfor.location,locationNotes: aInfor.locationNotes,fileName: aInfor.fileName,lastmodified:aInfor.lastModified,enabled:aInfor.enabled)
//                                            print("add:\(OInfor.id!)")
//                                            self.fetchInf()
//                                            self.table.reloadData()
//                                        }
//                                    }
//
//
//                                }
//
//                            }
//                        }
//
//
//
//                    } catch let jsonErr {
//
//                        print("Error decoding JSON", jsonErr)
//                    }
//                    }.resume()
//            }
//            let date = Date()
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            let todayString = formatter.string(from: date)
//            UserDefaults.standard.set(todayString, forKey: "todayStringKey")
//
//        }
//
//        func save(id: String?, title: String?, artist: String?, yearOfWork: String?,information: String?,lat: String? ,long: String? , location: String?,locationNotes: String?,fileName: String?, lastmodified: String?,enabled: String?) {
//
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//                return
//            }
//
//            let managedContext = appDelegate.persistentContainer.viewContext
//
//            let entity = NSEntityDescription.entity(forEntityName: "ArtworkInformation", in: managedContext)!
//            let ArtworkInformation = NSManagedObject(entity: entity, insertInto: managedContext)
//            ArtworkInformation.setValue(id, forKeyPath: "id")
//            ArtworkInformation.setValue(title, forKeyPath: "title")
//            ArtworkInformation.setValue(artist, forKeyPath: "artist")
//            ArtworkInformation.setValue(yearOfWork, forKeyPath: "yearOfWork")
//            ArtworkInformation.setValue(information, forKeyPath: "information")
//            ArtworkInformation.setValue(lat, forKeyPath: "lat")
//            ArtworkInformation.setValue(long, forKeyPath: "long")
//            ArtworkInformation.setValue(location, forKeyPath: "location")
//            ArtworkInformation.setValue(locationNotes, forKeyPath: "locationNotes")
//            ArtworkInformation.setValue(fileName, forKeyPath: "fileName")
//            ArtworkInformation.setValue(lastmodified, forKey: "lastModified")
//            ArtworkInformation.setValue(enabled, forKey: "enabled")
//
//
//
//
//            do {
//                try managedContext.save()
//
//
//            } catch let error as NSError {
//                print("Could not save. \(error), \(error.userInfo)")
//            }
//        }
//
//        func update(id: String?, title: String?, artist: String?, yearOfWork: String?,information: String?,lat: String? ,long: String? , location: String?,locationNotes: String?,fileName: String?, lastmodified: String?,enabled: String?) {
//
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//                return
//            }
//
//            let managedContext = appDelegate.persistentContainer.viewContext
//
//            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ArtworkInformation")
//            fetchRequest.predicate = NSPredicate(format: "id == %@", id!)
//            do {
//                let result = try managedContext.fetch(fetchRequest) as! [ArtworkInformation]
//                for infor in result {
//                    infor.id = id
//                    infor.title = title
//                    infor.artist = artist
//                    infor.yearOfWork = yearOfWork
//                    infor.information = information
//                    infor.lat = lat
//                    infor.long = long
//                    infor.location = location
//                    infor.locationNotes = locationNotes
//                    infor.fileName = fileName
//                    infor.lastModified = lastmodified
//                    infor.enabled = enabled
//                }
//            } catch let error as NSError {
//                print("Could not fetch. \(error), \(error.userInfo)")
//            }
//
//        }
//
//
//        func fetchInf(){
//
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//                return
//            }
//
//            let managedContext = appDelegate.persistentContainer.viewContext
//            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ArtworkInformation")
//
//            do {
//                let a = fetchRequest
//                a.sortDescriptors = [NSSortDescriptor.init(key: "location", ascending: true)]
//                markers = try managedContext.fetch(a) as! [ArtworkInformation]
//                //            for a in markers{
//                //                print(a.location!)
//                //            }
//            } catch let error as NSError {
//                print("Could not fetch. \(error), \(error.userInfo)")
//            }
//        }
//
//        func Arraybylocation(){
//
//            for i in 0...markers.count-1{
//                let lat = markers[i].lat
//                let latitude = Double(lat!)
//                let lon = markers[i].long
//                let longitude = Double(lon!)
//
//                //                let a = latitude!
//                //                let b
//                let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = coordinate
//                annotation.title = markers[i].location //显示什么？
//                self.map.addAnnotation(annotation)
//
//            }
//
//
//            var locationlist : [String] = []
//            //            var locationNoteList: [String] = []
//            var distance : [Double] = []
//            var locationAndDistance: [String : Double] = [String : Double]()
//            var finalLocationlist : [String] = []
//
//            //         var locationlist : [String] = []
//            var lat : [Double] = []
//            var long : [Double] = []
//
//
//
//            var howManyArtWorksInLocation : [Int] = []
//            var startlocation = markers[0].location!
//            //            var startlocationNote = markers[0].locationNotes!
//            let startlocationLat = (Double)(markers[0].lat!)!
//            let startlocationLong = (Double)(markers[0].long!)!
//            //         var distance : [Double] = []
//            var a = 0
//            var b = 0
//
//            locationlist.append(startlocation)
//            //            locationNoteList.append(startlocationNote)
//            lat.append(startlocationLat)
//            long.append(startlocationLong)
//            for aArt in markers{
//
//                if aArt.location! == startlocation{
//                    b = b+1
//                }
//                else{
//                    howManyArtWorksInLocation.append(b)
//                    b = 1
//                    startlocation = aArt.location!
//                    locationlist.append(aArt.location!)
//                    lat.append((Double)(aArt.lat!)!)
//                    long.append((Double)(aArt.long!)!)
//
//
//                }
//                a = a+1
//            }
//            howManyArtWorksInLocation.append(b)
//
//            for i in 0...locationlist.count-1{
//
//                let artLcLocation = CLLocation(latitude:CLLocationDegrees(lat[i]), longitude: CLLocationDegrees(long[i]))
//                //            print(userLoc!)
//
//                let artToUser = artLcLocation.distance(from: userLoc)
//                distance.append(artToUser)
//            }
//
//
//            for i in 0...distance.count-1{
//                //            print("\(locationlist[i]) : \(distance[i])")
//                locationAndDistance[locationlist[i]] = distance[i]
//            }
//
//
//            let result4 = locationAndDistance.sorted { (str1, str2) -> Bool in
//                return str1.1 < str2.1
//            }
//
//            for key in 0...result4.count-1{
//                finalLocationlist.append(result4[key].key)
//            }
//            self.locationBydistance = finalLocationlist
//
//            for i in 0..<finalLocationlist.count{
//                var eachLocation: [ArtworkInformation] = []
//                for aArt in self.markers{
//                    if aArt.location! == finalLocationlist[i]  {
//                        eachLocation.append(aArt)
//                    }
//                }
//                self.sectionByLocation[finalLocationlist[i]] = eachLocation
//            }
//            //        for i in 0...finalLocationlist.count-1{
//            //            print(finalLocationlist[i])
//            //        }
//            //        print(result4)
//            //        for a in locationlist{
//            //            distance = userLoc.distance(from: a)
//            //                    }
//
//        }
//
//        private func mapView(mapView:MKMapView, didSelectAnnotationView view:MKAnnotationView){
//
//            print("didSelectAnnotationView")
//
//        }
//
//    }

}
