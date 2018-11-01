//
//  EditProfileViewController.swift
//  ParkingSystem
//
//  Created by Yilei Pan on 31/10/18.
//  Copyright © 2018 Yilei.Pan. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    
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
    }
    
    @IBAction func saveChange(_ sender: Any) {
        // update the firebase
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
