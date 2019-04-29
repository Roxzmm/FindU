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
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var passwordNotice: UILabel!
    
    let databaseUtil = DatabaseConnectUtil()
    var response: (Bool, String) = (false, "")
    
    func createAccount() -> Bool{
        var boolCreated = false
        
        let inputHandler = InputHandlerUtil()
        
        // Store new user info and upload to mysql
        let username = userNameInput.text!
        let email = emailInput.text!
        let password = passwordInput.text!
        
        let checkName = inputHandler.checkUserName(username)
        let checkEmail = inputHandler.checkEmail(email)
        let checkPassword = inputHandler.checkPassword(password)
        
        if checkName == true && checkEmail == true && checkPassword == true {
            response = databaseUtil.createNewUser(username, email, password)
            if response.0 == true {
                
                databaseUtil.signIn("userEmail", email, password, false)
                boolCreated = true

                // do sth to tell the user that he created successfully
                
            }else {
                // back to main menu or recreate
                // need a new back navigator
                let alertController = UIAlertController(title: "Sorry", message:
                    response.1, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Done", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
                emailInput.text = ""
                passwordInput.text = ""
                userNameInput.text = ""
            }
        }
        
        if checkName == false {
            userNameInput.text = ""
            userNameInput.attributedPlaceholder = NSAttributedString(string: "Please do not input more than 10 chars.", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
        }
        if checkEmail == false {
            emailInput.text = ""
            emailInput.attributedPlaceholder = NSAttributedString(string: "Please input correct email address.", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
        }
        if checkPassword == false {
            passwordInput.text = ""
            passwordNotice.isHighlighted = true
        }
        return boolCreated
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


    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "detailregister" {
            return createAccount()
        } else {
            return false
        }
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        // pass userId to register successfully view
        if let vc = segue.destination as? RegisterSuccessfullyorFailedViewController{
            vc.userID = response.1
            vc.userName = userNameInput.text ?? "user"
        }

    }
    

}
