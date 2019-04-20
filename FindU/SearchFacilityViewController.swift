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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Search")
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
