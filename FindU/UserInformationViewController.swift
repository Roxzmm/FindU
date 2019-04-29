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
            let photo = UIImage(data: photoData)
            print(photoData)
            self.UserPhoto.image = photo
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
            let imageHelper = AppImageHelper()
            let resizeImage = imageHelper.resizeImage(originalImg: image)
            let data = imageHelper.compressImageSize(image: image)
            let resizeData = imageHelper.compressImageSize(image: resizeImage)
            print(image.pngData())
            print(data)
            print(resizeImage.pngData())
            print(resizeData)
            self.UserPhoto.image = UIImage(data: data)
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
