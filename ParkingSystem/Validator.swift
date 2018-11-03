//
//  Validator.swift
//  ParkingSystem
//
//  Created by Yilei Pan on 2/11/18.
//  Copyright © 2018 Yilei.Pan. All rights reserved.
//

import Foundation

class Validator {
    
    init() { }
    
    static func email(input: String) -> Bool {
        let regexStr = "[A-Z0-9a-z.-_]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: regexStr)
            let results = regex.matches(in: input, range: NSRange(location: 0, length: input.count))
            if results.count == 0 {
                return false
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            return false
        }
        return true
    }
    
    static func password(input: String) -> Bool {
        // At least 1 upper, 1 lower, 1 number, length 8-20
        let regexStr = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,20}$"
        do {
            let regex = try NSRegularExpression(pattern: regexStr)
            let results = regex.matches(in: input, range: NSRange(location: 0, length: input.count))
            if results.count == 0 {
                return false
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            return false
        }
        return true
    }
    
    static func name(input: String) -> Bool {
        let regexStr = "^[A-Za-z .']+$"
        do {
            let regex = try NSRegularExpression(pattern: regexStr)
            let results = regex.matches(in: input, range: NSRange(location: 0, length: input.count))
            if results.count == 0 {
                return false
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            return false
        }
        return true
    }
    
    static func address(input: String) -> Bool {
        return true
    }
    
    // https://stackoverflow.com/questions/39990179/regex-for-australian-phone-number-validation
    static func phone(input: String) -> Bool {
        let regexStr = "^(?:\\+?(61))? ?(?:\\((?=.*\\)))?(0?[2-57-8])\\)? ?(\\d\\d(?:[- ](?=\\d{3})|(?!\\d\\d[- ]?\\d[- ]))\\d\\d[- ]?\\d[- ]?\\d{3})$"
        do {
            let regex = try NSRegularExpression(pattern: regexStr)
            let results = regex.matches(in: input, range: NSRange(location: 0, length: input.count))
            if results.count == 0 {
                return false
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            return false
        }
        return true
    }
    
    static func plate(input: String) -> Bool {
        let regexStr = "^[A-Z0-9a-z]{6}$"
        do {
            let regex = try NSRegularExpression(pattern: regexStr)
            let results = regex.matches(in: input, range: NSRange(location: 0, length: input.count))
            if results.count == 0 {
                return false
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            return false
        }
        return true
    }
}
