//
//  PersonalInfoViewController.swift
//  ParkingSystem
//
//  Created by Yilei Pan on 31/10/18.
//  Copyright © 2018 Yilei.Pan. All rights reserved.
//

import UIKit
import Firebase

class PersonalInfoViewController: UIViewController{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userId = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userId!)
        ref.observe(.value, with: { snapshot in
            let data = snapshot.value as! [String: AnyObject]
            self.nameLabel.text = data["name"] as? String
            self.addressLabel.text = data["address"] as? String
            self.phoneLabel.text = data["phone"] as? String
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register the table view cell class and its reuse id
       
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
       // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {}
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToInfo(segue: UIStoryboardSegue) {}
    
    @IBAction func edit(_ sender: Any) {
        performSegue(withIdentifier: "goEdit", sender: nil)
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
