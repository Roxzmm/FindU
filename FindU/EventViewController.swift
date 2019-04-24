//
//  EventViewController.swift
//  FindU
//
//  Created by 张景 on 2019/3/27.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var addFunc: UIImageView!
    
    @IBOutlet weak var Event1: UIImageView!
    
    @IBOutlet weak var Event2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Event")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.view.backgroundColor = UIColorFromHex(rgbValue:1029623,alpha: 1)
        
        self.addFunc.image = UIImage(named: "addFunc.png")
        
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
