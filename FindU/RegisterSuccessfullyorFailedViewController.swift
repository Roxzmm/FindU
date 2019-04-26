//
//  registerSuccessfullyorFailedViewController.swift
//  FindU
//
//  Created by 张景 on 2019/4/25.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit

class RegisterSuccessfullyorFailedViewController: UIViewController {

    @IBOutlet weak var detailAboutRegister: UILabel!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    var userID: String = ""
    var userName: String = ""
    
    @IBAction func backToMenu(_ sender: Any) {
         performSegue(withIdentifier: "BackTomenu", sender: self)
        
    }
    override func viewDidLoad() {
        helloLabel.text = "Hello " + userName
        userIDLabel.text = "your userID is " + userID
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColorFromHex(rgbValue:1029623,alpha: 1)
    
        //TO DO: display userID
        
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
