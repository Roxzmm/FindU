//
//  SignInViewController.swift
//  FindU
//
//  Created by 张景 on 2019/3/27.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var SignIntitle: UIImageView!
    @IBOutlet weak var UserIDlabel: UILabel!
    @IBOutlet weak var UserIDText: UITextField!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var signinBtn: UIButton!
    
    let databaseUtil = DatabaseConnectUtil()
    
    @IBAction func register(_ sender: Any) {
        
         performSegue(withIdentifier: "ToRegister", sender: self)
        
    }
    
    
    @IBAction func signIn(_ sender: Any) {
  
        // Uncomment it to switch back to main view after sign in
//         performSegue(withIdentifier: "SignInBacktoMenu", sender: self)
        
        let identityInfo = UserIDText.text!
        let passwordInfo = PasswordText.text!
        
        let signStatus = sign(identityInfo, passwordInfo)
        if  signStatus.0 == true {
            // used to test sign in
            SignIntitle.isHidden = true
            UserIDText.isHidden = true
            UserIDlabel.text = "Congratulation! You have signed in successfully!"
            PasswordText.isHidden = true
            PasswordLabel.isHidden = true
            registerBtn.isHidden = true
            signinBtn.isHidden = true

        }
    }
    
    func sign(_ identity: String, _ password: String) -> (Bool, errorIdentity: String){
        
        var boolSign = false
        let errorIdentity = "Wrong credential! Please check your user identity and password!"
        
        let signStatus = databaseUtil.validateUser(identity, password)
        boolSign = signStatus.0
        
        
        return (boolSign, errorIdentity)
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
        
        var signIntitleCenter = self.SignIntitle.center
        signIntitleCenter.x += 200
        self.SignIntitle.center = signIntitleCenter
        signIntitleCenter.x -= 200
        
        
        UIView.animate(withDuration: 1, delay: 0.4 ,options: UIView.AnimationOptions.curveEaseInOut,  animations:{
            
            self.logo.image = UIImage(named: "logo.png")
            self.logo.center = logoCenter
            self.SignIntitle.image = UIImage(named: "SignIn.png")
            self.SignIntitle.center = signIntitleCenter
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
