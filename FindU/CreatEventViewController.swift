//
//  CreatEventViewController.swift
//  FindU
//
//  Created by 张景 on 2019/4/27.
//  Copyright © 2019 Jing. All rights reserved.
//

import UIKit

class CreatEventViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var eventNameText: UITextField!
    
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBOutlet weak var locationText: UITextField!
    
    @IBOutlet weak var dateText: UITextField!
    
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var addPosterBtn: UIButton!
    
    @IBOutlet weak var posterView: UIImageView!
    
    @IBOutlet weak var posterLabel: UILabel!
    
    let mysqlConnect = DatabaseConnectUtil()
    
    // to dismiss the keyboard when user click return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    @IBAction func addPosterAction(_ sender: Any) {
        CameraHandlerUtil.shared.showActionSheet(vc: self)
        CameraHandlerUtil.shared.imagePickedBlock = { (image) in
            self.posterLabel.isHidden = true
            self.posterView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Dismiss keyboard after clikcing return
        eventNameText.delegate = self
        locationText.delegate = self
        
        showDatePicker()
        // Do any additional setup after loading the view.
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        
        datePicker.minimumDate = Date.init()
        datePicker.maximumDate = Date.init(timeIntervalSinceNow: 2592000)
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dateText.inputAccessoryView = toolbar
        dateText.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateText.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func createEvent() -> Bool {
        var boolCreated = false
        
        let inputHandler = InputHandlerUtil()
        
        // Store new event info and upload to mysql
        let eventName = eventNameText.text!
        let eventDescription = descriptionText.text!
        let location = locationText.text!
        let time = dateText.text!
        
        let checkName = inputHandler.checkName(eventName, "event")
        let checkDescription = inputHandler.checkEventDescription(eventDescription)
        var checkLocation = false
        if location.count <= 30 {
            checkLocation = true
        }
        var checkTime = false
        var dateAndTime = Date.init()
        if let temp = inputHandler.stringToDate(time)  {
            dateAndTime = temp
            checkTime = true
        }
    
        if checkName == true && checkDescription == true && checkLocation == true && checkTime == true {
            boolCreated = mysqlConnect.uploadEvent(eventName, eventDescription, location, dateAndTime, posterView.image)
           if boolCreated == false {
                let alertController = UIAlertController(title: "Sorry", message:
                    "event creation fails.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Done", style: .default))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        if checkName == false {
            eventNameText.text = ""
            eventNameText.attributedPlaceholder = NSAttributedString(string: "Please do not input more than 20 chars.", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
        }
        if checkDescription == false {
            descriptionText.text = ""
            let alertController = UIAlertController(title: "Sorry", message:
                "Please do not input more than 40 chars in description field.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Done", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
        if checkLocation == false {
            locationText.text = ""
            locationText.attributedPlaceholder = NSAttributedString(string: "Please do not input more than 30 chars.", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
        }
        if checkTime == false {
            dateText.text = ""
            dateText.attributedPlaceholder = NSAttributedString(string: "Please choose a date and time", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
        }
        
        return boolCreated
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "BackToEventList" {
            return createEvent()
        }else {
            return false
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
