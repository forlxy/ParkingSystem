//
//  RegisterViewController.swift
//  ParkingSystem
//
//  Created by Yilei Pan on 31/10/18.
//  Copyright © 2018 Yilei.Pan. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField

//The following is for gradient background
// https://www.youtube.com/watch?v=3gUNg3Jhjwo
//extension UIView {
//    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = bounds
//        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
//        gradientLayer.locations = [0.0, 1.0]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
//        layer.insertSublayer(gradientLayer, at: 0)
//    }
//}


class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var addressTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(phoneTextFieldDidChange(_:)), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(nameTextFieldDidChange(_:)), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(addressTextFieldDidChange(_:)), for: .editingChanged)
        
        //The following is for gradient background
//        view.setGradientBackground(colorOne: UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0), colorTwo: UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0))
        
    }
    
    @IBAction func registerAccount(_ sender: Any) {
        if (emailTextField.hasErrorMessage || passwordTextField.hasErrorMessage || phoneTextField.hasErrorMessage || nameTextField.hasErrorMessage || addressTextField.hasErrorMessage) {
            return
        }
        guard let email = emailTextField.text, emailTextField.text?.count != 0 else {
            displayErrorMessage("Please enter a email address")
            return
        }
        guard let password = passwordTextField.text, passwordTextField.text?.count != 0 else {
            displayErrorMessage("Please enter a password")
            return
        }
        guard let name = nameTextField.text, nameTextField.text?.count != 0 else {
            displayErrorMessage("Please enter a name")
            return
        }
        guard let phone = phoneTextField.text, phoneTextField.text?.count != 0 else {
            displayErrorMessage("Please enter a phone")
            return
        }
        guard let address = addressTextField.text, addressTextField.text?.count != 0 else {
            displayErrorMessage("Please enter an address")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                self.displayErrorMessage(error!.localizedDescription)
            } else {
                let userId = Auth.auth().currentUser?.uid
                let ref = Database.database().reference().child("users").child(userId!)
                ref.child("name").setValue(name)
                ref.child("address").setValue(address)
                ref.child("phone").setValue(phone)
                ref.child("current").setValue(-1)
                ref.child("balance").setValue(0)
            }
        }
        let alert = UIAlertController(title: "Success", message: "You have registered now.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (_) in
            self.performSegue(withIdentifier: "unwindToAuth", sender: self)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayErrorMessage(_ errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func emailTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if (Validator().email(input: text) == false) {
                    floatingLabelTextField.errorMessage = "Invalid email"
                } else {
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @objc func passwordTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if (Validator().password(input: text) == false) {
                    floatingLabelTextField.errorMessage = "Invalid password"
                } else {
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @objc func phoneTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if (Validator().phone(input: text) == false) {
                    floatingLabelTextField.errorMessage = "Invalid phone number"
                } else {
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @objc func nameTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if (Validator().name(input: text) == false) {
                    floatingLabelTextField.errorMessage = "Name must not contain any special characters"
                } else {
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    @objc func addressTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if (Validator().address(input: text) == false) {
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
