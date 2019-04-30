//
//  JoinInViewController.swift
//  FindU
//
//  Created by 张景 on 2019/4/26.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit
import MapKit

class JoinInViewController: UIViewController {

    @IBOutlet weak var successMessage: UILabel!
    @IBOutlet weak var eventMap: MKMapView!
    @IBOutlet weak var posterView: UIImageView!
    
    let mysqlConnect = DatabaseConnectUtil()
    var event: Event? = nil
    var buildings:[Building] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showEventLocation()
        // Do any additional setup after loading the view.
          buildings = mysqlConnect.fetchBuildings()
        //show success message
        let localUser = mysqlConnect.retrieveLocalUser()
        let username = localUser?.name!
        successMessage.text = "Congratulations! \(String(describing: username)))"
        
        if let imageData = event?.poster! {
            let poster = UIImage(data: imageData)
            posterView.image = poster
        }
        
        // to do: show location
    }
    
    
    func showEventLocation(){
        var buildAim = [String]()
        let locationName = event?.place
        for build in buildings{
            if locationName == build.name{
                buildAim.append(build.position!)
            }
        }
        
        let locationOfStartPlace =  buildAim[0].components(separatedBy: ", ")
        
        let lat = locationOfStartPlace[0]
        let latitude = Double(lat)
        let lon = locationOfStartPlace[1]
        let longitude = Double(lon)
        
        let latDelta: CLLocationDegrees = 0.005
        let lonDelta: CLLocationDegrees = 0.005
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location1 = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let region = MKCoordinateRegion(center: location1, span: span)
        self.eventMap.setRegion(region, animated: true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
