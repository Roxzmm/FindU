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
    @IBOutlet weak var SignInView: UIView!
    @IBOutlet weak var signInBtn: UIButton!
    
    let databaseUtil = DatabaseConnectUtil()
    
    func signIn() -> Bool{
        var boolSigned = false
        
        let inputHandler = InputHandlerUtil()
        
        let identityInfo = UserIDText.text!
        let passwordInfo = PasswordText.text!
        
        if identityInfo.count > 0 && passwordInfo.count > 0 {
            let identityType = inputHandler.checkIdentityType(identityInfo)
            
            let signStatus = databaseUtil.signIn(identityType, identityInfo, passwordInfo, false)
            if  signStatus.0 == true {
                boolSigned = true
                
            }else {
                let alertController = UIAlertController(title: "Sorry!", message:
                    signStatus.identity, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Understand", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        return boolSigned
    }
    
//    @IBAction func signIn(_ sender: Any) {
//
//        let inputHandler = InputHandlerUtil()
//
//        let identityInfo = UserIDText.text!
//        let passwordInfo = PasswordText.text!
//
//        if identityInfo.count > 0 && passwordInfo.count > 0 {
//            let identityType = inputHandler.checkIdentityType(identityInfo)
//
//            let signStatus = databaseUtil.signIn(identityType, identityInfo, passwordInfo, false)
//            if  signStatus.0 == true {
//                let alertController = UIAlertController(title: "Congratulation!", message:
//                    signStatus.identity, preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "Continue", style: .default))
//
//                self.present(alertController, animated: true, completion: nil)
//
//            }else {
//                let alertController = UIAlertController(title: "Sorry!", message:
//                    signStatus.identity, preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "Understand", style: .default))
//
//                self.present(alertController, animated: true, completion: nil)
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
         self.SignInView.backgroundColor = UIColorFromHex(rgbValue:1029623,alpha: 1)
        
        
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
    

    
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "SignInBacktoMenu" {
            return signIn()
        }else if identifier == "ToRegister" {
            return true
        }else {
            return false
        }
    }
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//
//        // pass userId to register successfully view
//
//    }
    

}
