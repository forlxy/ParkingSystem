//
//  AuthViewController.swift
//  ParkingSystem
//
//  Created by Yilei Pan on 31/10/18.
//  Copyright © 2018 Yilei.Pan. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField

//import LFLoginController
//
////3. Implement the LFLoginControllerDelegate
//extension AuthViewController: LFLoginControllerDelegate {
//
//    func forgotPasswordTapped(email: String) {
//        print("forgot password")
//    }
//
//    func loginDidFinish(email: String, password: String, type: LFLoginController.SendType) {
//
//        print(email)
//        print(password)
//        print(type)
//    }
//}

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil {
                self.jumpToHome()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingChanged)
//
//        //1. Create a LFLoginController instance
//        let loginController = LFLoginController()
//        loginController.delegate = self
//        
//        // Customizations
//        loginController.logo = #imageLiteral(resourceName: "car")
//        loginController.isSignupSupported = true
//        
//        loginController.backgroundColor = UIColor(red: 224 / 255, green: 68 / 255, blue: 98 / 255, alpha: 1)
//        loginController.loginButtonColor = UIColor.cyan
//        
        //2. Present the timePicker
//        self.navigationController?.pushViewController(loginController, animated: true)
        
        // Do any additional setup after loading the view.
        
        // The following is to set background image and button
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-parking.png")!).withAlphaComponent(0.7)
//        loginButton.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
//        loginButton.layer.cornerRadius = 5
//        loginButton.layer.borderWidth = 1
//        loginButton.layer.borderColor = UIColor.gray.withAlphaComponent(0.8).cgColor
//        registerButton.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
//        registerButton.layer.cornerRadius = 5
//        registerButton.layer.borderWidth = 1
//        registerButton.layer.borderColor = UIColor.gray.withAlphaComponent(0.8).cgColor
    }
    
    @IBAction func loginAccount(_ sender: Any) {
        if (emailTextField.hasErrorMessage) {
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
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                self.displayErrorMessage(error!.localizedDescription)
            }
        }
    }
    
    func jumpToHome() {
        let tabBarController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        tabBarController.selectedViewController = tabBarController.viewControllers?[0]
        present(tabBarController, animated: true, completion: nil)
    }
    
    
    @IBAction func registerAccount(_ sender: Any) {
        self.performSegue(withIdentifier: "registerSegue", sender: nil)
    }
    
    func displayErrorMessage(_ errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToAuth(segue: UIStoryboardSegue) {}

    @objc func emailTextFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if (Validator.email(input: text) == false) {
                    floatingLabelTextField.errorMessage = "Invalid email"
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
