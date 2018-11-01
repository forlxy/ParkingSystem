//
//  RegisterViewController.swift
//  ParkingSystem
//
//  Created by Yilei Pan on 31/10/18.
//  Copyright © 2018 Yilei.Pan. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerAccount(_ sender: Any) {
        guard let email = emailTextField.text, emailTextField.text?.count != 0 else {
            displayErrorMessage("Please enter a email address")
            return
        }
        guard let password = passwordTextField.text, passwordTextField.text?.count != 0 else {
            displayErrorMessage("Please enter a password")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                self.displayErrorMessage(error!.localizedDescription)
            }
        }
        
        
        
        let userId = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userId!)
        ref.child("name").setValue(nameTextField.text)
        ref.child("address").setValue(addressTextField.text)
        ref.child("phone").setValue(phoneTextField.text)
        ref.child("current").setValue(-1)
        ref.child("balance").setValue(0)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
