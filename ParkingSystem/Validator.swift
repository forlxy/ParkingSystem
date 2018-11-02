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
    
    func email(input: String) -> Bool {
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
    
    func password(input: String) -> Bool {
        // 2 upper, 2 lower, 2 number, 1 special char, length 8-20
        let regexStr = "^(?=.*[A-Z].*[A-Z])(?=.*[a-z].*[a-z])(?=.*[0-9].*[0-9])(?=.*[!@#$&*]).{8,20}$"
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
    
    func name(input: String) -> Bool {
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
    
    func address(input: String) -> Bool {
        return true
    }
    
    // https://stackoverflow.com/questions/39990179/regex-for-australian-phone-number-validation
    func phone(input: String) -> Bool {
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
    
    func plate(input: String) -> Bool {
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
