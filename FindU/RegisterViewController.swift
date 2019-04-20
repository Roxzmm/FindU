//
//  RegisterViewController.swift
//  FindU
//
//  Created by 张景 on 2019/3/28.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var registerTitle: UILabel!
    @IBOutlet weak var userNameInput: UITextField!
    @IBOutlet weak var EmailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBAction func CreateBtn(_ sender: Any) {
        
        
        performSegue(withIdentifier: "RegisterBackToMenu", sender: self)
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.view.backgroundColor = UIColorFromHex(rgbValue:1029623,alpha: 1)
        
        var logoCenter = self.logo.center
        logoCenter.x -= 200
        self.logo.center = logoCenter
        logoCenter.x += 200
        
        var registerCenter = self.registerTitle.center
        registerCenter.x += 200
        self.registerTitle.center = registerCenter
        registerCenter.x -= 200
        
        UIView.animate(withDuration: 1, delay: 0.4 ,options: UIView.AnimationOptions.curveEaseInOut,  animations:{
            
            self.logo.image = UIImage(named: "logo.png")
            self.logo.center = logoCenter
            self.registerTitle.center = registerCenter
        },completion: { finished in
            UIView.animate(withDuration: 1){
                
                
                
                
            }
            print("SignIn page finished")
        })
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
