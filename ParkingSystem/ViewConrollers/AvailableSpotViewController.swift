//
//  AvailableSpotViewController.swift
//  ParkingSystem
//
//  Created by Yilei Pan on 31/10/18.
//  Copyright © 2018 Yilei.Pan. All rights reserved.
//

import UIKit
import Firebase

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

class AvailableSpotViewController: UIViewController {

    @IBOutlet weak var spot1: UIImageView!
    @IBOutlet weak var spot2: UIImageView!
    @IBOutlet weak var spot3: UIImageView!
    @IBOutlet weak var spot4: UIImageView!
    
    let ref = Database.database().reference().child("park")
    
    let ref2 = Database.database().reference().child("users")
//    var currentIndex = -1
    let userId = Auth.auth().currentUser?.uid
    var currentPlate = ""
    var plates = [String]()
    
    var times = [String](repeating: "", count: 4)
    
    var invalids = [String](repeating: "", count: 4)
    
    @objc func onDidReceiveData(_ notification:Notification) {
        // Do something now
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    @objc func orderGesture(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            let identifier = gesture.view?.restorationIdentifier
            let alert = UIAlertController(title: "Do you want to order this spot?", message: "Please select the plate.", preferredStyle: .actionSheet)
            
            let closure = { (action: UIAlertAction!) -> Void in
                let index = alert.actions.index(of: action)
                
                if index != nil {
                    
                    self.checkOrdered(identifier: identifier!, index: index!)
                    
//
                }
            }
            
            for element in plates {
                alert.addAction(UIAlertAction(title: element, style: .default, handler: closure))
            }

            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
        }
    }

    @objc func cancelGesture(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            let identifier = gesture.view?.restorationIdentifier
            let alert = UIAlertController(title: "Do you want to cancel your order?", message: "We'll miss you.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.cancelOrder(identifier: identifier!, plotIndex: Int(String(identifier!.last!))!)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
        }
    }
    
    func orderSpot(identifier: String, index: Int) {
        let currentDateTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd HH mm ss"
        let stringDate = dateFormatter.string(from: currentDateTime)
        
        ref.child("\(identifier)/plate").setValue(self.plates[index])
        ref.child("\(identifier)/state").setValue(1)
        ref.child("\(identifier)/order").setValue(stringDate)
        ref.child("\(identifier)/invalid").setValue("")
    }
    
    func cancelOrder(identifier: String, plotIndex: Int) {
        ref.child("\(identifier)/plate").setValue(invalids[plotIndex])
        if(invalids[plotIndex] != ""){
            ref.child("\(identifier)/state").setValue(2)
        }
        else{
            ref.child("\(identifier)/state").setValue(0)
        }
        ref.child("\(identifier)/order").setValue("")
        ref.child("\(identifier)/invalid").setValue("")
    }
    
    func checkOrdered(identifier: String, index: Int){
        ref.queryOrdered(byChild: "state").queryEqual(toValue: 1).observeSingleEvent(of: .value, with: { snapshot in
//            print(snapshot.childrenCount)
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot{
                    let data = snap.value as! [String: AnyObject]
//                    print(data)
                    if(data["plate"] as! String == self.plates[index]){
                        let alert = UIAlertController(title: "This car has already ordered a plot", message: "Please choose another car", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        
                        self.present(alert, animated: true)
                        return
//                        print(data["plate"])
                    }
                }
            }
            self.orderSpot(identifier: identifier, index: index)
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: NSNotification.Name(rawValue: "Notify"), object: nil)
        
        ref2.child(userId!).observe(.value, with: { snapshot in
            self.plates.removeAll()
            let plates = snapshot.childSnapshot(forPath: "plates")
            for child in plates.children {
                if let snapshot = child as? DataSnapshot{
                    let plate = snapshot.value as! String
                    self.plates.append(plate)
                    //                    let index = snapshot.key
                    //                    if(Int(index) == self.currentIndex){
                    //                        self.currentPlate = plate
                    //                    }
                }
                
            }
            
            
        })
        
        
        let ref_plot_0 = ref.child("plot_0")
        let ref_plot_1 = ref.child("plot_1")
        let ref_plot_2 = ref.child("plot_2")
        let ref_plot_3 = ref.child("plot_3")
        
        // add it to the image view;
        //        spot1.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        spot1.isUserInteractionEnabled = true
        //        spot2.addGestureRecognizer(tapGesture)
        spot2.isUserInteractionEnabled = true
        //        spot3.addGestureRecognizer(tapGesture)
        spot3.isUserInteractionEnabled = true
        //        spot4.addGestureRecognizer(tapGesture)
        spot4.isUserInteractionEnabled = true
        
        ref_plot_0.observe(.value, with: { snapshot in
            
            let data = snapshot.value as! [String: AnyObject]
            let orderGesture = UITapGestureRecognizer(target: self, action: #selector(AvailableSpotViewController.orderGesture(gesture:)))
            let cancelGesture = UITapGestureRecognizer(target: self, action: #selector(AvailableSpotViewController.cancelGesture(gesture:)))
            
            
            self.times[0] = data["order"] as! String
            self.invalids[0] = data["invalid"] as! String
            
            if(self.plates.contains(self.invalids[0]) && self.times[0] == "expired"){
                ref_plot_0.child("invalid").setValue("")
                ref_plot_0.child("order").setValue("")
                let alert = UIAlertController(title: "Your order is expired", message: "Reservation for a order lasts for 30min", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
            switch data["state"] as! Int{
            case 0:
                self.spot1.removeGestureRecognizer(cancelGesture)
                self.spot1.addGestureRecognizer(orderGesture)
                self.spot1.setImageColor(color: UIColor.green)
                self.spot1.isUserInteractionEnabled = true
            case 1:
                self.spot1.removeGestureRecognizer(orderGesture)
                self.spot1.setImageColor(color: UIColor.red)
                self.spot1.isUserInteractionEnabled = false
                if(self.plates.contains(data["plate"] as! String)){
                    if(self.invalids[0] != "") {
                        let alert = UIAlertController(title: "Your ordered port 1 is occupied by car with plate:" + self.invalids[0] , message: "", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                    }
                    self.spot1.addGestureRecognizer(cancelGesture)
                    self.spot1.setImageColor(color: UIColor.orange)
                    self.spot1.isUserInteractionEnabled = true
                }
                
            case 2:
                self.spot1.setImageColor(color: UIColor.red)
                self.spot1.isUserInteractionEnabled = false
            default:
                self.spot1.removeGestureRecognizer(cancelGesture)
                self.spot1.addGestureRecognizer(orderGesture)
                self.spot1.setImageColor(color: UIColor.green)
                self.spot1.isUserInteractionEnabled = true
            }
            
        })
        
        ref_plot_1.observe(.value, with: { snapshot in
            let data = snapshot.value as! [String: AnyObject]
            let orderGesture = UITapGestureRecognizer(target: self, action: #selector(AvailableSpotViewController.orderGesture(gesture:)))
            let cancelGesture = UITapGestureRecognizer(target: self, action: #selector(AvailableSpotViewController.cancelGesture(gesture:)))
            
            
            self.times[1] = data["order"] as! String
            self.invalids[1] = data["invalid"] as! String
            
            if(self.plates.contains(self.invalids[1]) && self.times[1] == "expired"){
                ref_plot_1.child("invalid").setValue("")
                ref_plot_1.child("order").setValue("")
                let alert = UIAlertController(title: "Your order is expired", message: "Reservation for a order lasts for 30min", preferredStyle: .alert)
                
//                NotificationCenter.default.post(name: NSNotification.Name("Your order is expired"), object: nil)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
            switch data["state"] as! Int{
            case 0:
                self.spot2.removeGestureRecognizer(cancelGesture)
                self.spot2.addGestureRecognizer(orderGesture)
                self.spot2.setImageColor(color: UIColor.green)
                self.spot2.isUserInteractionEnabled = true
            case 1:
                self.spot2.removeGestureRecognizer(orderGesture)
                self.spot2.setImageColor(color: UIColor.red)
                self.spot2.isUserInteractionEnabled = false
                if(self.plates.contains(data["plate"] as! String)){
                    if(self.invalids[1] != "") {
                        let alert = UIAlertController(title: "Your ordered port 2 is occupied by car with plate:" + self.invalids[1] , message: "", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
//                        NotificationCenter.default.post(name: NSNotification.Name("Your ordered port 2 is occupied by car with plate:" + self.invalids[1]), object: nil)
                    }
                    self.spot2.addGestureRecognizer(cancelGesture)
                    self.spot2.setImageColor(color: UIColor.orange)
                    self.spot2.isUserInteractionEnabled = true
                }
            case 2:
                self.spot2.setImageColor(color: UIColor.red)
                self.spot2.isUserInteractionEnabled = false
            default:
                self.spot2.removeGestureRecognizer(cancelGesture)
                self.spot2.addGestureRecognizer(orderGesture)
                self.spot2.setImageColor(color: UIColor.green)
                self.spot2.isUserInteractionEnabled = true
            }
            
        })
        
        ref_plot_2.observe(.value, with: { snapshot in
            let data = snapshot.value as! [String: AnyObject]
            let orderGesture = UITapGestureRecognizer(target: self, action: #selector(AvailableSpotViewController.orderGesture(gesture:)))
            let cancelGesture = UITapGestureRecognizer(target: self, action: #selector(AvailableSpotViewController.cancelGesture(gesture:)))
            
            
            self.times[2] = data["order"] as! String
            self.invalids[2] = data["invalid"] as! String
            
            if(self.plates.contains(self.invalids[2]) && self.times[2] == "expired"){
                ref_plot_2.child("invalid").setValue("")
                ref_plot_2.child("order").setValue("")
                let alert = UIAlertController(title: "Your order is expired", message: "Reservation for a order lasts for 30min", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
            switch data["state"] as! Int{
            case 0:
                self.spot3.removeGestureRecognizer(cancelGesture)
                self.spot3.addGestureRecognizer(orderGesture)
                self.spot3.setImageColor(color: UIColor.green)
                self.spot3.isUserInteractionEnabled = true
            case 1:
                self.spot3.removeGestureRecognizer(orderGesture)
                self.spot3.setImageColor(color: UIColor.red)
                self.spot3.isUserInteractionEnabled = false
                if(self.plates.contains(data["plate"] as! String)){
                    if(self.invalids[2] != "") {
                        let alert = UIAlertController(title: "Your ordered port 3 is occupied by car with plate:" + self.invalids[2] , message: "", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                    }
                    self.spot3.addGestureRecognizer(cancelGesture)
                    self.spot3.setImageColor(color: UIColor.orange)
                    self.spot3.isUserInteractionEnabled = true
                }
            case 2:
                self.spot3.setImageColor(color: UIColor.red)
                self.spot3.isUserInteractionEnabled = false
            default:
                self.spot3.removeGestureRecognizer(cancelGesture)
                self.spot3.addGestureRecognizer(orderGesture)
                self.spot3.setImageColor(color: UIColor.green)
                self.spot3.isUserInteractionEnabled = true
            }
            
        })
        
        ref_plot_3.observe(.value, with: { snapshot in
            let data = snapshot.value as! [String: AnyObject]
            let orderGesture = UITapGestureRecognizer(target: self, action: #selector(AvailableSpotViewController.orderGesture(gesture:)))
            let cancelGesture = UITapGestureRecognizer(target: self, action: #selector(AvailableSpotViewController.cancelGesture(gesture:)))
            
            
            self.times[3] = data["order"] as! String
            self.invalids[3] = data["invalid"] as! String
            
            if(self.plates.contains(self.invalids[3]) && self.times[3] == "expired"){
                ref_plot_3.child("invalid").setValue("")
                ref_plot_3.child("order").setValue("")
                let alert = UIAlertController(title: "Your order is expired", message: "Reservation for a order lasts for 30min", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
            switch data["state"] as! Int{
            case 0:
                self.spot4.removeGestureRecognizer(cancelGesture)
                self.spot4.addGestureRecognizer(orderGesture)
                self.spot4.setImageColor(color: UIColor.green)
                self.spot4.isUserInteractionEnabled = true
            case 1:
                self.spot4.removeGestureRecognizer(orderGesture)
                self.spot4.setImageColor(color: UIColor.red)
                self.spot4.isUserInteractionEnabled = false
                if(self.plates.contains(data["plate"] as! String)){
                    if(self.invalids[3] != "") {
                        let alert = UIAlertController(title: "Your ordered port 4 is occupied by car with plate:" + self.invalids[3] , message: "", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                    }
                    self.spot4.addGestureRecognizer(cancelGesture)
                    self.spot4.setImageColor(color: UIColor.orange)
                    self.spot4.isUserInteractionEnabled = true
                }
            case 2:
                self.spot4.setImageColor(color: UIColor.red)
                self.spot4.isUserInteractionEnabled = false
            default:
                self.spot4.removeGestureRecognizer(cancelGesture)
                self.spot4.addGestureRecognizer(orderGesture)
                self.spot4.setImageColor(color: UIColor.green)
                self.spot4.isUserInteractionEnabled = true
            }
            
        })
        // Do any additional setup after loading the view.
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
