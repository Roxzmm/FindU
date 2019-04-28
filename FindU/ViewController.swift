//
//  ViewController.swift
//  FindU
//
//  Created by 张景 on 2019/3/26.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit
import CoreData
import OHMySQL

class ViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var welcometitle: UIImageView!
    @IBOutlet weak var searchfacility: UIImageView!
    @IBOutlet weak var event: UIImageView!
    @IBOutlet weak var me: UIImageView!
    
    // sync database
    var loadCount = 0
//    var boolSigned = false
    let mysqlConnect = DatabaseConnectUtil()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mysqlConnect.configureMySQL()

        if loadCount == 0 {
//            let mysqlConnect = DatabaseConnectUtil()

            // Try to retrieve local user data and sign in automatically
            if let localUser = mysqlConnect.retrieveLocalUser() {
                mysqlConnect.signIn("userEmail", localUser.email, localUser.password, true)
            }

            mysqlConnect.sync()
            if mysqlConnect.checkUpdateStatus(table: "user").0 == false && mysqlConnect.boolSigned == true{
                mysqlConnect.updateUserInfo()
            }

            self.loadCount += 1
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
            self.view.backgroundColor = UIColorFromHex(rgbValue:1029623,alpha: 1)
            
            var logoCenter = self.logo.center
            logoCenter.x -= 200
            self.logo.center = logoCenter
            logoCenter.x += 200
            
            var welcometitleCenter = self.welcometitle.center
            welcometitleCenter.x += 200
            self.welcometitle.center = welcometitleCenter
            welcometitleCenter.x -= 200
            
            var searchfacilityCenter = self.searchfacility.center
            searchfacilityCenter.x -= 200
            self.searchfacility.center = searchfacilityCenter
            searchfacilityCenter.x += 200
            
            
            
            var meCenter = self.me.center
            meCenter.x -= 200
            self.me.center = meCenter
            meCenter.x += 200
            
            var eventCenter = self.event.center
            eventCenter.x += 200
            self.event.center = eventCenter
            eventCenter.x -= 200
            
            UIView.animate(withDuration: 1, delay: 0.4 ,options: UIView.AnimationOptions.curveEaseInOut,  animations:{
                
                self.logo.image = UIImage(named: "logo.png")
                self.logo.center = logoCenter
                self.welcometitle.image = UIImage(named: "welcometitle.png")
                self.welcometitle.center = welcometitleCenter
            },completion: { finished in
                UIView.animate(withDuration: 1){
                    
                    self.searchfacility.image = UIImage(named: "searchfacility.png")
                    self.searchfacility.center = searchfacilityCenter
                    
                    
                    
                    self.event.image = UIImage(named: "event.png")
                    self.event.center = eventCenter
                    
                    self.me.image = UIImage(named: "me.png")
                    self.me.center = meCenter
                    
                    
                }
                print("Start page finished")
            })
        
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let goSearchFacility = UITapGestureRecognizer(target: self, action: #selector(wayToSearch(tapGestureRecognizer:)))
        searchfacility.isUserInteractionEnabled = true
        searchfacility.addGestureRecognizer(goSearchFacility)
        
        let goEvent = UITapGestureRecognizer(target: self, action: #selector(wayToEvent(tapGestureRecognizer:)))
        event.isUserInteractionEnabled = true
        event.addGestureRecognizer(goEvent)
        
        let goMe = UITapGestureRecognizer(target: self, action: #selector(wayToMe(tapGestureRecognizer:)))
        me.isUserInteractionEnabled = true
        me.addGestureRecognizer(goMe)
        
    }
    
    @objc func wayToSearch(tapGestureRecognizer: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: "Tosearchfacility", sender: self)
        
    }
    
    @objc func wayToEvent(tapGestureRecognizer: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: "Toevent", sender: self)
        
    }
    
    @objc func wayToMe(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if mysqlConnect.boolSigned == false {
            performSegue(withIdentifier: "ToMe", sender: self)
            
        }else {
            //TO DO: finish UI: User Information Management
            performSegue(withIdentifier: "ToUserInformation", sender: self)
            // Just for testing, delete this after finishing UI
        }
            
    }


}


func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}

