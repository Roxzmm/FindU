//
//  UserInformationViewController.swift
//  FindU
//
//  Created by 张景 on 2019/4/27.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var attribute: UILabel!
    @IBOutlet weak var value: UILabel!
    
    class var identifier: String {
        return String(describing: self)
    }
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configureWithItem(_ attributes: String, _ values: String) {
        // setImageWithURL(url: item.avatarImageURL)
        attribute.text = attributes
        value.text = values
    }
}

extension UserInformationViewController: UITableViewDelegate {
}

extension UserInformationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            UserInfoTableViewCell.identifier, for: indexPath) as? UserInfoTableViewCell
        {
            cell.configureWithItem(attributes[indexPath.item], values[indexPath.item])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
            return 4
    }
}

class UserInformationViewController: UIViewController {
    @IBOutlet weak var UserInforTitle: UILabel!
    @IBOutlet weak var UserPhoto: UIImageView!
    @IBOutlet weak var UserInformationTableView: UITableView!
    @IBOutlet weak var addPhotoBtn: UIImageView!
    
    let mysqlConnect = DatabaseConnectUtil()
    var user: User? = nil
    
    var cells = [UserInfoTableViewCell]()
    let attributes = ["Name:", "userID:", "Email:", "Credit:"]
    var values: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = mysqlConnect.retrieveLocalUser()
        
        UserInformationTableView.register(UserInfoTableViewCell.nib, forCellReuseIdentifier: UserInfoTableViewCell.identifier)
        UserInformationTableView.delegate = self
        UserInformationTableView.dataSource = self
        
        values = [user?.name, user?.userID, user?.email, user?.credit] as! [String]
        
        self.UserInformationTableView.reloadData()
        
        addPhotoBtn.image = UIImage(named: "camera.png")
        UserPhoto.image = UIImage(named: "userphoto.png")
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
