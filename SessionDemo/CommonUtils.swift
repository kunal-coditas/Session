//
//  CommonUtils.swift
//  SessionDemo
//
//  Created by kunal on 29/09/17.
//  Copyright © 2017 coditas. All rights reserved.
//

import Foundation

class CommonUtils {
    class func log(logString: String){
        print(logString)
    }
}

extension String  {
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
}

extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).sync {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}
