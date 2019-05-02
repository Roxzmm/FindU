//
//  EventDetailViewController.swift
//  FindU
//
//  Created by 张景 on 2019/4/26.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit

class commentPrototypeCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var commentOwnerLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var dislikeBtn: UIButton!
    
}

class EventDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = comments.count
        if count <= 6 {
            return comments.count
        }else {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! commentPrototypeCell

        cell.contentLabel.text = comments[indexPath.row].content
        
        cell.likeBtn.addTarget(self, action: #selector(like(sender:)), for: UIControl.Event.touchUpInside)
        
        cell.dislikeBtn.addTarget(self, action: #selector(disLike(sender:)), for: UIControl.Event.touchUpInside)
        
        self.indexRow = indexPath.row
        
        let tempName = comments[indexPath.row].ownerName!
        let tempCredit = comments[indexPath.row].ownerCredit!
        let name = "@" + tempName + "/" + tempCredit
        cell.commentOwnerLabel.text = name
        
//        mysqlConnect.sync(["Comment"])
//        self.comments = mysqlConnect.fetchComments(event!)
//        self.commentsTableView.reloadData()
        self.view.layoutIfNeeded()

        return cell
    }
    
    @objc func like(sender : UIButton!) {
        let commentSelected = comments[indexRow]
        print(commentSelected.content)
        if DatabaseConnectUtil.boolSigned == true {
            mysqlConnect.updateCredit(commentSelected, true)
        }else {
            let alertController = UIAlertController(title: "Sorry", message:
                "you haven't signed in.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Done", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func disLike(sender: UIButton!) {
        let commentSelected = comments[indexRow]

        if DatabaseConnectUtil.boolSigned == true {
            mysqlConnect.updateCredit(commentSelected, false)
        }else {
            let alertController = UIAlertController(title: "Sorry", message:
                "you haven't signed in.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Done", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    var indexRow = 0
    
    @IBOutlet weak var posterView: UIImageView!
    
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var eventHostLabel: UILabel!
    
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    @IBOutlet weak var eventLocationLabel: UILabel!
    
    @IBOutlet weak var numParticipantsLabel: UILabel!
    
    var commentContent: String?
    
    let mysqlConnect = DatabaseConnectUtil()
    var event: Event? = nil
    
    var comments: [Comment] = []
    
    override func viewWillAppear(_ animated: Bool) {
//        if commentContent != nil {
//            if commentContent?.count != 0 {
//                uploadComment(commentContent!)
//                if mysqlConnect.checkUpdateStatus(table: "comment").0 == false {
//                    mysqlConnect.sync(["Comment"])
//                }
//                commentsTableView.reloadData()
//            }
//        }
        
        mysqlConnect.sync(["Comment"])
        self.comments = mysqlConnect.fetchComments(event!)
        self.commentsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        comments = mysqlConnect.fetchComments(event!)
        commentsTableView.reloadData()
        self.view.layoutIfNeeded()
        if mysqlConnect.checkUpdateStatus(table: "comment").0 == false {
            mysqlConnect.sync(["Comment"])
        }
        if mysqlConnect.checkUpdateStatus(table: "event").0 == false {
            mysqlConnect.syncEvents()
        }
        
        if event != nil {
            eventNameLabel.text = event!.name!
            let hostname = event!.hostName!
            let hostcredit = event!.hostCredit!
            
            let num = event?.numOfParticipant! as! String
            numParticipantsLabel.text = "Number of participants: \(num)"
            
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
    
    func uploadComment(_ commentContent: String) -> Bool{
        var boolUploaded = true
        
        let eventId = event?.eventID as! String
     
        if mysqlConnect.uploadComment(eventId, commentContent) != true {
            boolUploaded = false
            
            let alertController = UIAlertController(title: "Sorry", message:
                "comment fails.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Done", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        return boolUploaded
    }
    
    @IBAction func createComment(_ sender: Any) {
        if DatabaseConnectUtil.boolSigned == true{
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Your Comment", message: "Enter your comment", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = ""
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                    // Force unwrapping because we know it exists.
                print("Text field: \(textField!.text)")
                self.commentContent = textField?.text
                
                if self.commentContent != nil {
                    if self.commentContent?.count != 0 {
                        self.uploadComment(self.commentContent!)
                        if self.mysqlConnect.checkUpdateStatus(table: "comment").0 == false {
                            self.mysqlConnect.sync(["Comment"])
                            self.comments = self.mysqlConnect.fetchComments(self.event!)
                        }
                        self.commentsTableView.reloadData()
                    }
                }
                
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
            
        }else {
            let alertController = UIAlertController(title: "Sorry", message:
                "you haven't signed in.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Done", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }

    }
    
//    func likeComment(_ Comment: Comment) {
//        if DatabaseConnectUtil.boolSigned == true {
//
//        }else {
//            let alertController = UIAlertController(title: "Sorry", message:
//                "you haven't signed in.", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Done", style: .default))
//
//            self.present(alertController, animated: true, completion: nil)
//        }
//    }

    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "ToJoinIn" {
            if DatabaseConnectUtil.boolSigned == true {
                let user = mysqlConnect.retrieveLocalUser()
                let userNo = user!.userID as! String
                let membersNo = event?.membersID as! String
                let members = membersNo.components(separatedBy: ", ")
                print(userNo)
                print(members)
                
                for member in members {
                    if member == userNo {
                        let alertController = UIAlertController(title: "Sorry", message:
                            "you are already in.", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Done", style: .default))
                        
                        self.present(alertController, animated: true, completion: nil)
                        return false
                    }
                }
                mysqlConnect.joinInEvent(event!)
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
