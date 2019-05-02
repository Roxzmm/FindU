//
//  FacilityDetailViewController.swift
//  FindU
//
//  Created by 张景 on 2019/4/30.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit

class FacilityPrototypeCell: UITableViewCell {
    
    @IBOutlet weak var facilityNameLabel: UILabel!
    @IBOutlet weak var facilityLocationLabel: UILabel!
    @IBOutlet weak var facilityStateLabel: UILabel!
}

class FacilityDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var buildingNameLable: UILabel!
    
    
    var building: Building?
    var facilityName = ""
    var facilityPosition = ""
    var aVailability = ""
    
    var facilities: [Facility] = []
    
    let mysqldatabaseUtil = DatabaseConnectUtil()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildingNameLable.text = building?.name
        
        let tempFacilities = mysqldatabaseUtil.fetchFacilities()
//        buildings = mysqldatabaseUtil.fetchBuildings()
        var facilityAim :[Facility] = []
        for arr in tempFacilities{
            let tempName = arr.name!
            if facilityName == tempName{
                print(facilityName)
                print(tempName)
//                let a = String((arr.facilityID?.prefix(4))!)
//                let b = String(a.suffix(3))
                //                    let test4 = String(testStr.prefix(5))
                
                facilityAim.append(arr)
            }
        }
        
        for F in facilityAim{

            let factemp = String((F.facilityID?.prefix(4))!)
            let facilityNo = String(factemp.suffix(3))

            let a = String(building!.buldingID!.prefix(6))
            let b = String(a.suffix(3))
                if facilityNo == b{
                    facilities.append(F)
                }
            
        }
        
        
//        FacilityName.text = facilityName
//        FacilityPosition.text = facilityName
//        availability.text = aVailability

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facilities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "facilityCell", for: indexPath) as! FacilityPrototypeCell
        
        let tempLocation = facilities[indexPath.row].floor!
        cell.facilityLocationLabel.text = "Location: \(tempLocation)"
        
        let tempName = facilities[indexPath.row].name!
        cell.facilityNameLabel.text = "Name: \(tempName)"
        
        let tempState = facilities[indexPath.row].state!
        cell.facilityStateLabel.text = "State: \(tempState)"
        
        return cell
    }

    

}
