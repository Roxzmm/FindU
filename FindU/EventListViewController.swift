//
//  EventListViewController.swift
//  FindU
//
//  Created by Rochus Xing on 2019/4/30.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController {
    
    @IBOutlet weak var createNewEvent: UIImageView!
    
    let mysqlConnect = DatabaseConnectUtil()
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNewEvent.image = UIImage(named: "addFunc.png")
        self.view.backgroundColor = UIColorFromHex(rgbValue:1029623,alpha: 1)
        events = mysqlConnect.fetchEvents()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let createEvent = UITapGestureRecognizer(target: self, action: #selector(wayToCreateNewEvent(tapGestureRecognizer:)))
        createNewEvent.isUserInteractionEnabled = true
        createNewEvent.addGestureRecognizer(createEvent)
        
    }
    
    @objc func wayToCreateNewEvent(tapGestureRecognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "ToCreateNewEvent", sender: self)
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
