//
//  EventDetailViewController.swift
//  FindU
//
//  Created by 张景 on 2019/4/26.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    @IBOutlet weak var EventPoster: UIImageView!
    
    @IBOutlet weak var EventName: UILabel!
    
    @IBOutlet weak var Organizer: UILabel!
    
    @IBOutlet weak var EventDescription: UILabel!
    
    @IBOutlet weak var addComment: UIImageView!
    
    @IBOutlet weak var UserPhoto1: UIImageView!
    
    @IBOutlet weak var Comment1: UILabel!
    
    @IBOutlet weak var UserName1: UILabel!
    
    @IBOutlet weak var UserPhoto2: UIImageView!
    
    @IBOutlet weak var Comment2: UILabel!
    @IBOutlet weak var UserName2: UILabel!
    @IBAction func JoinInBtn(_ sender: Any) {
    }
    @IBOutlet weak var bottom: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
