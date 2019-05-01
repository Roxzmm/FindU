//
//  EventDetailViewController.swift
//  FindU
//
//  Created by 张景 on 2019/4/26.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = comments.count
        if count <= 10 {
            return comments.count
        }else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell")
        
        return cell!
    }
    

    @IBOutlet weak var posterView: UIImageView!
    
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var eventHostLabel: UILabel!
    
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    @IBOutlet weak var eventLocationLabel: UILabel!
    
    let mysqlConnect = DatabaseConnectUtil()
    var event: Event? = nil
    
    var comments: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if mysqlConnect.checkUpdateStatus(table: "comment").0 == false {
            mysqlConnect.sync(["Comment"])
        }
        if event != nil {
            eventNameLabel.text = event!.name!
            let hostname = event!.hostName!
            let hostcredit = event!.hostCredit!
            
            eventHostLabel.text = "Organizer: @\( hostname)/\(hostcredit)"
            print(event?.date)
            eventTimeLabel.text = event!.date!.description
            eventLocationLabel.text = event!.place
            eventDescriptionLabel.text = event!.eventDescription
            
            if let imageData = event?.poster {
                let poster = UIImage(data: imageData)
                posterView.image = poster
            }
            // Do any additional setup after loading the view.
            comments = mysqlConnect.fetchComments(event!)
            commentsTableView.reloadData()
        }
    }
    
    @IBAction func createComment(_ sender: Any) {
        if DatabaseConnectUtil.boolSigned == true{
            
            
            
        }else {
            let alertController = UIAlertController(title: "Sorry", message:
                "you haven't signed in.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Done", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func likeComment(_ Comment: Comment) {
        if DatabaseConnectUtil.boolSigned == true {
            
        }else {
            let alertController = UIAlertController(title: "Sorry", message:
                "you haven't signed in.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Done", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }

    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "ToJoinIn" {
            if DatabaseConnectUtil.boolSigned == true {
                let user = mysqlConnect.retrieveLocalUser()
                let userNo = user!.userID
                let membersNo = event?.membersID
                let members = membersNo?.components(separatedBy: ", ")
                
                for member in members! {
                    if member == userNo {
                        let alertController = UIAlertController(title: "Sorry", message:
                            "you are already in.", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Done", style: .default))
                        
                        self.present(alertController, animated: true, completion: nil)
                        return false
                    }
                }
                return true
            }else {
                let alertController = UIAlertController(title: "Sorry", message:
                    "you haven't signed in.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Done", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
                return false
            }
        }else {
            return false
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // pass userId to register successfully view
        if let vc = segue.destination as? JoinInViewController{
            vc.event = event
            mysqlConnect.joinInEvent(event!)
        }
    }

}
