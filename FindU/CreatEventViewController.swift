//
//  CreatEventViewController.swift
//  FindU
//
//  Created by 张景 on 2019/4/27.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit

class CreatEventViewController: UIViewController {
    @IBOutlet weak var CreateEventTitle: UILabel!
    @IBOutlet weak var EventName: UITextField!
    @IBOutlet weak var EventDetail: UITextField!
    @IBOutlet weak var EventLocation: UITextField!
    @IBOutlet weak var EventTime: UITextField!
    
    @IBOutlet weak var addEventPoster: UIImageView!
    @IBOutlet weak var EventPoster: UIImageView!
    @IBOutlet weak var CreateBtn: UIButton!
    
    
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
