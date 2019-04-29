//
//  UserInformationViewController.swift
//  FindU
//
//  Created by 张景 on 2019/4/27.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit

class UserInformationViewController: UIViewController {
    @IBOutlet weak var UserInforTitle: UILabel!
    @IBOutlet weak var UserPhoto: UIImageView!
    @IBOutlet weak var addPhotoBtn: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userScore: UILabel!
    
    let mysqlConnect = DatabaseConnectUtil()
    var user: User? = nil
    
    let attributes = ["Name:", "userID:", "Email:", "Credit:"]
    var values: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mysqlConnect.checkUpdateStatus(table: "user").0 == false {
            mysqlConnect.updateUserInfo()
        }

        self.user = mysqlConnect.retrieveLocalUser()
        
        userName.text = user?.name
        id.text = user?.userID
        userEmail.text = user?.email
        userScore.text = user?.credit
        
        addPhotoBtn.image = UIImage(named: "camera.png")
        UserPhoto.image = UIImage(named: "userphoto.png")
        
        if let photoData = user?.userPhoto {
            let photo = UIImage(data: photoData)!
            
            let imageHelper = AppImageHelper()
            self.UserPhoto.image = imageHelper.resizeImage(originalImg: photo)
        }
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        let addUserPhoto = UITapGestureRecognizer(target: self, action: #selector(addPhoto(tapGestureRecognizer:)))
        addPhotoBtn.isUserInteractionEnabled = true
        addPhotoBtn.addGestureRecognizer(addUserPhoto)
        
    }
    
    @objc func addPhoto(tapGestureRecognizer: UITapGestureRecognizer) {
        
        CameraHandlerUtil.shared.showActionSheet(vc: self)
        CameraHandlerUtil.shared.imagePickedBlock = { (image) in
            self.UserPhoto.image = image
            
            self.mysqlConnect.uploadUserPhoto(image)
        }
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
