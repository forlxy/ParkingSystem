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
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        ref2.child(userId!).observe(.value, with: { snapshot in
            self.plates.removeAll()
            let plates = snapshot.childSnapshot(forPath: "plates")
            let data = snapshot.value as! [String: AnyObject]
//            self.currentIndex = data["current"] == nil ? -1 : data["current"] as! Int
//            if(self.currentIndex == -1){
//                self.currentPlate = ""
//            }
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
    }
    
    
    @objc func orderGesture(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            let identifier = gesture.view?.restorationIdentifier
            let alert = UIAlertController(title: "Do you want to order this spot?", message: "Please select the plate.", preferredStyle: .actionSheet)
            
            let closure = { (action: UIAlertAction!) -> Void in
                let index = alert.actions.index(of: action)
                
                if index != nil {
                    self.orderSpot(identifier: identifier!, index: index!)
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
                self.cancelOrder(identifier: identifier!)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
        }
    }
    
    func orderSpot(identifier: String, index: Int) {
        ref.child("\(identifier)/plate").setValue(self.plates[index])
        ref.child("\(identifier)/state").setValue(1)
    }
    
    func cancelOrder(identifier: String) {
        ref.child("\(identifier)/plate").setValue("")
        ref.child("\(identifier)/state").setValue(0)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
