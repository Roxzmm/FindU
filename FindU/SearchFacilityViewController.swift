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


class SearchFacilityViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{
    
    var startName = ""
    var facility = ""
    
    var startAnnotation = MKPointAnnotation()
    
    var facilityAnnotation :[MKPointAnnotation] = []
   
   
    var startPosition = [String]()
    var markers: [Marker] = []
    var facilities:[Facility] = []
    var buildings:[Building] = []
    
    let mysqldatabaseUtil = DatabaseConnectUtil()
    var result = [String]()
    var searching = false
    
    var facilityName:[String] = ["Common Room","Drinking Machine","Hot Water","Meeting Room","Men's Room","Microwave","PC Room","Printer","Water Dispenser"]

    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var StartPositionSB: UISearchBar!
   
    @IBOutlet weak var FacilitySB: UISearchBar!
    
    @IBOutlet weak var FacilityTableView: UITableView!
    
    @IBOutlet weak var startPositionView: UITableView!
    
    

    
    //    @IBOutlet weak var bottomBar: UITabBar!
    
     var locationManager = CLLocationManager()
   
    
    override func viewWillAppear(_ animated: Bool) {
        
        StartPositionSB.barTintColor = .gray
        StartPositionSB.searchBarStyle = .minimal
        
        FacilitySB.barTintColor = .gray
        FacilitySB.searchBarStyle = .minimal
        
        markers = mysqldatabaseUtil.fetchMarkers()
//        Facility = mysqldatabaseUtil.fetchFacility()
        
        
        for BuildName in self.markers{
            self.result.append(BuildName.buildingName!)
        }
        startPosition = self.result
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
                startPositionView.isHidden = true
                FacilityTableView.isHidden = true
       
        //还需要facility的所有名字
        
//        self.StartPositionSB.delegate = self
//        self.startPositionView.delegate = self
//        self.startPositionView.dataSource = self
//        self.StartPositionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableCell")
        //        self.FacilitySB.delegate = self as? UISearchBarDelegate
        
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        
        //        Arraybylocation()
        
        
      
    }
    override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
    }
    
    @IBAction func SearchBtn(_ sender: Any) {
        if startName != "" && facility == ""{
        var aim = [String]()
        for arr in markers{
            if arr.buildingName == startName{
                aim.append(arr.location!)
            }
        }
        
        let locationOfStartPlace = aim[0].components(separatedBy: ", ")
        
        let lat = locationOfStartPlace[0]
        let latitude = Double(lat)
        let lon = locationOfStartPlace[1]
        let longitude = Double(lon)
        
        let latDelta: CLLocationDegrees = 0.005
        let lonDelta: CLLocationDegrees = 0.005
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location1 = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let region = MKCoordinateRegion(center: location1, span: span)
        self.map.setRegion(region, animated: true)
        
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
//        let annotation = MKPointAnnotation()
        self.startAnnotation.coordinate = coordinate
        self.startAnnotation.title = startName //显示什么？
        self.map.addAnnotation(self.startAnnotation)
        //        facility
        }
        
        if startName != "" && facility != ""{
            
            var aim = [String]()
            for arr in markers{
                if arr.buildingName == startName{
                    aim.append(arr.location!)
                }
            }
            
            let locationOfStartPlace = aim[0].components(separatedBy: ", ")
            
            let lat = locationOfStartPlace[0]
            let latitude = Double(lat)
            let lon = locationOfStartPlace[1]
            let longitude = Double(lon)
            
            let latDelta: CLLocationDegrees = 0.005
            let lonDelta: CLLocationDegrees = 0.005
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let location1 = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            let region = MKCoordinateRegion(center: location1, span: span)
            self.map.setRegion(region, animated: true)
            
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            //        let annotation = MKPointAnnotation()
            self.startAnnotation.coordinate = coordinate
            self.startAnnotation.title = startName //显示什么？
            self.map.addAnnotation(self.startAnnotation)
            
            facilities = mysqldatabaseUtil.fetchFacilities()
            buildings = mysqldatabaseUtil.fetchBuildings()
            var facilityAim :[String] = []
            for arr in facilities{
                
                if facility == arr.name{
                    let a = String((arr.facilityID?.prefix(4))!)
                    let b = String(a.suffix(3))
//                    let test4 = String(testStr.prefix(5))
                  
                    facilityAim.append(b)
                }
            }
            var Building = [String]()
            var Buildings: [Building] = []
            
            
           
            for F in facilityAim{
                for B in buildings{
                let a = String(B.buldingID!.prefix(6))
                let b = String(a.suffix(3))
                    if F == b{
                        Building.append(B.position!)
                        Buildings.append(B)
                    }
                }
            }
            
            
            for i in 0...Building.count-1{

                let location = Building[i]

                if location.count != 0{
                    let location5 = location.components(separatedBy: ", ")

                    let lat = location5[0]
                    let latitude = Double(lat)
                    let lon = location5[1]
                    let longitude = Double(lon)


                    let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                    let annotation = MKPointAnnotation()
                    facilityAnnotation.append(annotation)
                    annotation.coordinate = coordinate
                    annotation.title = Buildings[i].name //显示什么？
                    self.map.addAnnotation(annotation)



                }
            }
            
            
            
        
        }
        if startName == "" && facility != ""{
            facilities = mysqldatabaseUtil.fetchFacilities()
            buildings = mysqldatabaseUtil.fetchBuildings()
            var facilityAim :[String] = []
            for arr in facilities{
                
                if facility == arr.name{
                    let a = String((arr.facilityID?.prefix(4))!)
                    let b = String(a.suffix(3))
                    //                    let test4 = String(testStr.prefix(5))
                    
                    facilityAim.append(b)
                }
            }
            var Building = [String]()
            var Buildings: [Building] = []
            
            
            
            for F in facilityAim{
                for B in buildings{
                    let a = String(B.buldingID!.prefix(6))
                    let b = String(a.suffix(3))
                    if F == b{
                        Building.append(B.position!)
                        Buildings.append(B)
                    }
                }
            }
            
            
            for i in 0...Building.count-1{
                
                let location = Building[i]
                
                if location.count != 0{
                    let location5 = location.components(separatedBy: ", ")
                    
                    let lat = location5[0]
                    let latitude = Double(lat)
                    let lon = location5[1]
                    let longitude = Double(lon)
                    
                    
                    let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                    let annotation = MKPointAnnotation()
                    facilityAnnotation.append(annotation)
                    annotation.coordinate = coordinate
                    annotation.title = Buildings[i].name //显示什么？
                    self.map.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
            
            
        
        
    }
   
  

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locationOfUser = locations[0]
        
        //            userLoc = locations[0]
        let latitude = locationOfUser.coordinate.latitude
        let longitude = locationOfUser.coordinate.longitude
        let latDelta: CLLocationDegrees = 0.005
        let lonDelta: CLLocationDegrees = 0.005
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
        
//        Arraybylocation()
    }
    
    
    func Arraybylocation(){
        markers = mysqldatabaseUtil.fetchMarkers()
        for i in 2...markers.count-1{
            
            let location = markers[i].location
            //            let location1 = location!.replacingOccurrences(of: "°", with: ".")
            //            let location2 = location1.replacingOccurrences(of: "\'", with: "")
            //            let location3 = location2.replacingOccurrences(of: "\"N", with: "")
            //            let location4 = location3.replacingOccurrences(of: "\"W", with: "")
            //            let location5 = location4.replacingOccurrences(of: " ", with: "")
            //            let location6 : [String] = location5.components(separatedBy: ", ")
            
            //            print(location)
            //            print(location6)
            if location?.count != 0{
                let location5 = location!.components(separatedBy: ", ")
                
                let lat = location5[0]
                let latitude = Double(lat)
                let lon = location5[1]
                let longitude = Double(lon)
                
                //                let a = latitude!
                //                let b
                let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = markers[i].buildingName //显示什么？
                self.map.addAnnotation(annotation)
            }
            
            //                            let a = latitude!
            //                            let b = longitude!
            //            let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            //            let annotation = MKPointAnnotation()
            //            annotation.coordinate = coordinate
            //            annotation.title = markers[i].location //显示什么？
            //            self.map.addAnnotation(annotation)
        }
        
        
        //        var locationlist : [String] = []
        //        //            var locationNoteList: [String] = []
        //        var distance : [Double] = []
        //        var locationAndDistance: [String : Double] = [String : Double]()
        //        var finalLocationlist : [String] = []
        //
        //        //         var locationlist : [String] = []
        //        var lat : [Double] = []
        //        var long : [Double] = []
        
        
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
        //        for i in 0...finalLocationlist.count-1{
        //            print(finalLocationlist[i])
        //        }
        //        print(result4)
        //        for a in locationlist{
        //            distance = userLoc.distance(from: a)
        //        }
        //
    }
    
    private func mapView(mapView:MKMapView, didSelectAnnotationView view:MKAnnotationView){
        
        print("didSelectAnnotationView")
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView == startPositionView{
        if searching{
           count  = result.count
        }else{
            count = startPosition.count
        }
        }
        
        if tableView == FacilityTableView{
            if searching{
                count = result.count
            }
            else{
                count = facilityName.count
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if tableView == startPositionView{
        if searching{
            cell?.textLabel?.text = result[indexPath.row]
            
        }else{
            cell?.textLabel?.text = startPosition[indexPath.row]
        }
        }
        
        else if tableView == FacilityTableView{
           if searching{
           cell?.textLabel?.text = result[indexPath.row]
        
        }else{
             cell?.textLabel?.text = facilityName[indexPath.row]
        }
        }
        return cell!
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        result = []
        if searchBar == StartPositionSB{
        result = startPosition.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        startPositionView.isHidden = false
        startPositionView.reloadData()
        
        }
        
        if searchBar == FacilitySB{
            result = facilityName.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        FacilityTableView.isHidden = false
        FacilityTableView.reloadData()
        }
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searching = false
        startPositionView.isHidden = true
        FacilityTableView.isHidden = true
        searchBar.text = ""
        startName = ""
        facility = ""
        startPositionView.reloadData()
        FacilityTableView.reloadData()
        self.map.removeAnnotation(self.startAnnotation)
        
        for arr in facilityAnnotation{
            self.map.removeAnnotation(arr)
        }
        facilityAnnotation = []
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searching = false
        startPositionView.isHidden = true
        FacilityTableView.isHidden = true
        startPositionView.reloadData()
        FacilityTableView.reloadData()
        StartPositionSB.resignFirstResponder()
        FacilitySB.resignFirstResponder()
        
    }
    
  
    
    
    var a = ""
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

          if tableView == startPositionView{
                StartPositionSB.text = result[indexPath.row]
                startName =  result[indexPath.row]
            startPositionView.isHidden = true
        }
        
        if tableView == FacilityTableView{
                FacilitySB.text =   result[indexPath.row]
                facility = result[indexPath.row]
            FacilityTableView.isHidden = true
    }

        }
   
    
}




