//
//  CommonModel.swift
//  iosDev
//
//  Created by kingdee on 2024/3/5.
//

import Foundation

@objcMembers class Person: NSObject {
    
    func sing() {
        debugPrint("\(self) sing")
    }
    
    @objc func talk() {
        debugPrint("\(self) talk")
    }
}

extension Person {
    
    func jump() {
        debugPrint("\(self) jump")
    }
}

class Student: Person {
    
    func run() {
        debugPrint("\(self) run")
    }
}


class Animal {
    
}

class Dog: Animal {
    
}
