//
//  CarsTableViewController.swift
//  ParkingSystem
//
//  Created by Yilei Pan on 31/10/18.
//  Copyright © 2018 Yilei.Pan. All rights reserved.
//

import UIKit
import Firebase

class CarsTableViewController: UITableViewController, UIGestureRecognizerDelegate{
    var cars: [Car] = []
    let ref = Database.database().reference().child("users")
    var currentIndex = -1
    let userId = Auth.auth().currentUser?.uid
    var latestTime = ""
    var timer = Timer()
    var isRunning = false
    
    @IBAction func addNew(_ sender: Any) {
        let alert = UIAlertController(title: "Add Car", message: "Please input your car plate", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.accessibilityHint = "Please input your car plate"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let plate = textField?.text
            if(plate != ""){
                let newCar = Car(isInside: false, plate: plate!, time: Date())
                self.cars.append(newCar)
                self.updateCars()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func updateCars() {
        for car in cars {
            let index = cars.index(of: car) as! Int
             ref.child(userId!).child("plates").child(String(index)).setValue(car.plate)
        }
        
        ref.child(userId!).child("current").setValue(-1)
        self.currentIndex = -1
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(CarsTableViewController.longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
        
        ref.child(userId!).observe(.value, with: { snapshot in
            self.cars.removeAll()
            let plates = snapshot.childSnapshot(forPath: "plates")
            let data = snapshot.value as! [String: AnyObject]
            self.currentIndex = data["current"] == nil ? -1 : data["current"] as! Int
            for child in plates.children {
                if let snapshot = child as? DataSnapshot{
                    let plate = snapshot.value as! String
                    let index = snapshot.key
//                    let plate = data[index] as! String
                    let newCar = Car(isInside: false, plate: plate, time: Date())
                    self.cars.append(newCar)
                }
                
            }
            
            
            //Update current "in" car of this user
            for (index, car) in self.cars.enumerated()    {
                let query = Database.database().reference().child("plate").child(car.plate).queryOrderedByKey().queryLimited(toLast: 1)
                var preAction = "out"
                var currentAction = "out"
                query.observe(.value, with:{ snapshot in
                    
                    for snap in snapshot.children {
                        
                        if let first = snap as? DataSnapshot{
                            for snapshoot in first.children {
                                if let final = snapshoot as? DataSnapshot{
                                    let data = final.value as! [String: AnyObject]
                                    let action = data["action"] as! String
                                    if(action == "in") {
                                        preAction = currentAction
                                        currentAction = action
                                        self.currentIndex = index
                                        self.latestTime = data["time"] as! String
                                    }
                                    else if(action == "out"){
                                        preAction = currentAction
                                        currentAction = action
                                        self.currentIndex = -1
                                    }
                                }
                            }
                        }
                    }
                    if(preAction != currentAction){
                        self.ref.child(self.userId!).child("current").setValue(self.currentIndex)
                    }
                    
                    self.tableView.reloadData()
                })
            }
            
            
            
            self.tableView.reloadData()
        })
        
        
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cars.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            let alert = UIAlertController(title: "You sure delete this car?", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                self.ref.child(self.userId!).child("plates").child(String(indexPath.row)).removeValue()
                self.cars.remove(at: indexPath.row)
                tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
        }
        
    }
    
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
//            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
//            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
//                let alert = UIAlertController(title: "Set this one as Default plate?", message: "", preferredStyle: .alert)
//
//                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
//                    self.ref.child(self.userId!).child("default").setValue(indexPath.row)
//                }))
//                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
//
//                self.present(alert, animated: true)
//            }
        }
    }
    
//    
//    override func tableView(_ tableView: UITableView,
//                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//    {
//        let closeAction = UIContextualAction(style: .normal, title:  "Close", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//            print("OK, marked as Closed")
//            success(true)
//        })
//        closeAction.image = UIImage(named: "tick")
//        closeAction.backgroundColor = .purple
//        
//        return UISwipeActionsConfiguration(actions: [closeAction])
//        
//    }
//    
//    override func tableView(_ tableView: UITableView,
//                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//    {
//        let modifyAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//            print("Update action ...")
//            success(true)
//        })
//        modifyAction.image = UIImage(named: "hammer")
//        modifyAction.backgroundColor = .blue
//        
//        return UISwipeActionsConfiguration(actions: [modifyAction])
//    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(CarsTableViewController.updateTimer)), userInfo: nil, repeats: true)
        isRunning = true
    }
    
    func stopTimer() {
        timer.invalidate()
        isRunning = false
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let ti = NSInteger(interval)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    
    @objc func updateTimer() {
        let interval = Date().timeIntervalSince(self.cars[currentIndex].time)
        
        let indexPath = IndexPath(row: currentIndex, section: 0)
        self.cars[currentIndex].labelText = stringFromTimeInterval(interval: interval) //This will update the label.
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath)

        cell.detailTextLabel?.text = (self.cars[currentIndex].isInside ? "Current Inside. Lasting: " : "") + self.cars[currentIndex].labelText
        cell.detailTextLabel?.textColor = UIColor.orange
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath)

        var stringDate = ""
        if(currentIndex == indexPath.row && latestTime != "")
        {
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy MM dd HH mm ss"
            var dateFromString: Date? = dateFormatter.date(from: self.latestTime)
            
            var dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "dd/MM/yyyy HH:mm:ss"
            stringDate = dateFormatter2.string(from: dateFromString!)
            
            self.cars[currentIndex].isInside = true
            
            self.cars[currentIndex].time = dateFromString!
        }
        // Configure the cell...

        if(currentIndex == -1 && isRunning == true){
            stopTimer()
        }
        else if(currentIndex != -1 && isRunning == false){
            runTimer()
        }
        
        
        let car = cars[indexPath.row]
        
        cell.textLabel?.text = car.plate
        
        if(currentIndex == indexPath.row && latestTime != "") {
            cell.detailTextLabel?.text = (car.isInside ? "Current Inside. Lasting: " : "") + self.cars[currentIndex].labelText
            cell.detailTextLabel?.textColor = UIColor.orange
        }
        else {
            cell.detailTextLabel?.text = ""
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Change Car Plate", message: "Please input your car plate", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.accessibilityHint = "Please input your car plate"
            textField.text = self.cars[indexPath.row].plate
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let plate = textField?.text
            if(plate != ""){
                self.cars[indexPath.row].plate = plate!
                self.updateCars()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
