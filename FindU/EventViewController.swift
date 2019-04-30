//
//  EventViewController.swift
//  FindU
//
//  Created by 张景 on 2019/3/27.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var createNewEvent: UIImageView!
    
    @IBOutlet weak var Event1: UIImageView!
    
    @IBOutlet weak var Event2: UIImageView!
    
    let mysqlConnect = DatabaseConnectUtil()
    
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Event view")
        
        events = mysqlConnect.fetchEvents()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.view.backgroundColor = UIColorFromHex(rgbValue:1029623,alpha: 1)
        
        createNewEvent.image = UIImage(named: "addFunc.png")
//        let goEvent = UITapGestureRecognizer(target: self, action: #selector(wayToEventDetail(tapGestureRecognizer:)))

//        Event1.image = UIImage(named: "logo.png")
//        Event1.isUserInteractionEnabled = true
//        Event1.addGestureRecognizer(goEvent)

//        Event2.isUserInteractionEnabled = true
//        Event2.addGestureRecognizer(goEvent)
        
        let createEvent = UITapGestureRecognizer(target: self, action: #selector(guideToCreateEvent(tapGestureRecognizer:)))
        createNewEvent.isUserInteractionEnabled = true
        createNewEvent.addGestureRecognizer(createEvent)
    }
    
    @objc func wayToEventDetail(tapGestureRecognizer: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: "ToEventDetail", sender: self)
    }
    
    @objc func guideToCreateEvent(tapGestureRecognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "ToCreateEvent", sender: self)
    }
    
    @objc func wayToAddEvent(tapGestureRecognizer: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: "ToCreateEvent", sender: self)
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
