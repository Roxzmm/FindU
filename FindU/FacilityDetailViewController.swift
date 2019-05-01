//
//  FacilityDetailViewController.swift
//  FindU
//
//  Created by 张景 on 2019/4/30.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit

class FacilityDetailViewController: UIViewController {

    @IBOutlet weak var FacilityName: UILabel!
    @IBOutlet weak var FacilityPosition: UILabel!
    @IBOutlet weak var availability: UILabel!
    
    var facilityName = ""
    var facilityPosition = ""
    var aVailability = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FacilityName.text = facilityName
        FacilityPosition.text = facilityName
        availability.text = aVailability

        // Do any additional setup after loading the view.
    }
    

    

}
