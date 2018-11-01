//
//  Car.swift
//  ParkingSystem
//
//  Created by Sam on 2018/10/31.
//  Copyright © 2018年 Yilei.Pan. All rights reserved.
//

import UIKit

class Car: NSObject {
    var isInside: Bool
    var plate: String = ""
    var timer: Timer
    
    init(isInside: Bool, plate: String, timer: Timer) {
        self.isInside = isInside
        self.plate = plate
        self.timer = timer
    }
    
}
