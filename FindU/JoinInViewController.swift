//
//  JoinInViewController.swift
//  FindU
//
//  Created by 张景 on 2019/4/26.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit

class JoinInViewController: UIViewController {

    @IBOutlet weak var successMessage: UILabel!
    
    let mysqlConnect = DatabaseConnectUtil()
    var event: Event? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //show success message
        let localUser = mysqlConnect.retrieveLocalUser()
        let username = localUser?.name!
        successMessage.text = "Congratulations! \(String(describing: username))"
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
