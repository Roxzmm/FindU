//
//  EventListViewController.swift
//  FindU
//
//  Created by Rochus Xing on 2019/4/30.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let count = events.count
//        if count <= 10 {
//            return events.count
//        }else {
//            return 10
//        }
        return  2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell")
//        cell?.imag
        cell?.textLabel?.text = "dasdjkfjakfafhasflksafjlskjfkajflkajsflksajflajsflksajfalksfjalsfjad"
//        cell?.textLabel?.preferredMaxLayoutWidth = eventTableView.bounds.width
//        cell?.textLabel?.text = events[indexPath.row].name
//
//        if cell?.textLabel?.text == nil {
//            cell?.textLabel?.text = "No events nearby."
//        }
//
//        var boolDisplayImage = false
//        if let imageData = events[indexPath.row].poster {
//            if let image = UIImage(data: imageData) {
//                boolDisplayImage = true
//                cell?.imageView?.image = image
//            }
//        }
//        if boolDisplayImage == false {
//            cell?.textLabel?.text = events[indexPath.row].eventDescription
//        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        eventSelected = events[indexPath.row]
        performSegue(withIdentifier: "ToVisitEventDetail", sender: self)
    }
    
    @IBOutlet weak var createNewEvent: UIImageView!
    
    @IBOutlet weak var eventTableView: UITableView!
    
      
    let mysqlConnect = DatabaseConnectUtil()
    var events: [Event] = []
    var eventSelected: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        eventTableView.estimatedRowHeight = 44.0
//        eventTableView.rowHeight = UITableView.automaticDimension
        if mysqlConnect.checkUpdateStatus(table: "event").0 == false {
            mysqlConnect.sync(["Event"])
        }
            
        createNewEvent.image = UIImage(named: "addFunc.png")
        self.view.backgroundColor = UIColorFromHex(rgbValue:1029623,alpha: 1)
        events = mysqlConnect.fetchEvents()
        
        // Do any additional setup after loading the view.
        eventTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let createEvent = UITapGestureRecognizer(target: self, action: #selector(wayToCreateNewEvent(tapGestureRecognizer:)))
        createNewEvent.isUserInteractionEnabled = true
        createNewEvent.addGestureRecognizer(createEvent)
        
        let viewEvent = UITapGestureRecognizer(target: self, action: #selector(wayToSpecificEvent(tapGestureRecognize:)))
        for eachVisibleCell in eventTableView.visibleCells {
            eachVisibleCell.isUserInteractionEnabled = true
            eachVisibleCell.addGestureRecognizer(viewEvent)
            if let index = eventTableView.indexPath(for: eachVisibleCell) {
                print(index)
            }
        }
    }
    
    @objc func wayToCreateNewEvent(tapGestureRecognizer: UITapGestureRecognizer) {
        if mysqlConnect.boolSigned == true {
            performSegue(withIdentifier: "ToCreateNewEvent", sender: self)
        }else {
            let alertController = UIAlertController(title: "Sorry", message:
                "you haven't signed in.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Done", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func wayToSpecificEvent(tapGestureRecognize: UITapGestureRecognizer) {
        performSegue(withIdentifier: "ToVisitEventDetail", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? EventDetailViewController{
            vc.event = eventSelected
        }

        
    }
}
