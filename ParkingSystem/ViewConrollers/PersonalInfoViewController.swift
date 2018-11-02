//
//  PersonalInfoViewController.swift
//  ParkingSystem
//
//  Created by Yilei Pan on 31/10/18.
//  Copyright © 2018 Yilei.Pan. All rights reserved.
//

import UIKit
import Firebase

class PersonalInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = nameText
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = "Address"
            cell.detailTextLabel?.text = addressText
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Phone"
            cell.detailTextLabel?.text = phoneText
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = nameText
            return cell
        }
        
        
    }
    

//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var addressLabel: UILabel!
//    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var infoTableView: UITableView!
    
    var nameText = "---"
    var addressText = "---"
    var phoneText = "---"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userId = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("users").child(userId!)
        ref.observe(.value, with: { snapshot in
            let data = snapshot.value as! [String: AnyObject]
            self.nameText = (data["name"] as? String)!
            self.addressText = (data["address"] as? String)!
            self.phoneText = (data["phone"] as? String)!
            self.infoTableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register the table view cell class and its reuse id
        infoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        infoTableView.delegate = self
        infoTableView.dataSource = self
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
