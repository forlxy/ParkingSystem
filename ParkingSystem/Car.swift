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
    var time: Date
    var labelText: String = ""
    
    init(isInside: Bool, plate: String, time: Date) {
        self.isInside = isInside
        self.plate = plate
        self.time = time
    }
    
}
