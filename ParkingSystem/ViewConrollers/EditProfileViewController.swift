//
//  EditProfileViewController.swift
//  ParkingSystem
//
//  Created by Yilei Pan on 31/10/18.
//  Copyright © 2018 Yilei.Pan. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField

class EditProfileViewController: UIViewController {

    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var addressTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userId = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userId!)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let data = snapshot.value as! [String: AnyObject]
            self.nameTextField.text = data["name"] as? String
            self.addressTextField.text = data["address"] as? String
            self.phoneTextField.text = data["phone"] as? String
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameTextField.addTarget(self, action: #selector(nameTextFieldDidChange(_:)), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(phoneTextFieldDidChange(_:)), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(addressTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func saveChange(_ sender: Any) {
        if (Validator.name(input: nameTextField.text!) && Validator.address(input: addressTextField.text!) && Validator.phone(input: phoneTextField.text!)) {
            let userId = Auth.auth().currentUser?.uid
            let ref = Database.database().reference().child("users").child(userId!)
            ref.child("name").setValue(nameTextField.text)
            ref.child("address").setValue(addressTextField.text)
            ref.child("phone").setValue(phoneTextField.text)
            let alert = UIAlertController(title: "Success", message: "You have changed your profile.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (_) in
                self.performSegue(withIdentifier: "unwindToInfo", sender: self)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            return
        }
    }
    
    @objc func nameTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if (Validator.name(input: text) == false) {
                    floatingLabelTextField.errorMessage = "Name must not contain any special characters"
                } else {
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @objc func phoneTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if (Validator.phone(input: text) == false) {
                    floatingLabelTextField.errorMessage = "Invalid phone"
                } else {
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @objc func addressTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if (Validator.address(input: text) == false) {
                    floatingLabelTextField.errorMessage = "Invalid address"
                } else {
                    floatingLabelTextField.errorMessage = ""
                }
            }
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
