//
//  testBitVC.swift
//  iosDev
//
//  Created by kingdee on 2024/1/30.
//

import Foundation

class BitsModel {
    /*
     采用位域来做bool值记录，这样可以更节省空间，也更方便多重条件处理；
     例：0b1111_1111, 从右到左依次为abcdefgh四个开关值。
     */
    var bytes: UInt8 = 0
    
    /*
     位运算直接写
     */
//    var flagA: Bool {
//        get {
//            return (((bytes >> 0) & 0x1) != 0)
//        }
//        set {
//            if newValue {
//                bytes = (bytes | 0x01)
//            } else {
//                bytes = (bytes & (~0x01))
//            }
//        }
//    }
//    var flagB: Bool {
//        get {
//            return (((bytes >> 1) & 0x1) != 0)
//        }
//        set {
//            if newValue {
//                bytes = (bytes | (0x01 << 1))
//            } else {
//                bytes = (bytes & (~(0x01 << 1)))
//            }
//        }
//    }
//    var flagD: Bool {
//        get {
//            return (((bytes >> 3) & 0x1) != 0)
//        }
//        set {
//            if newValue {
//                bytes = (bytes | (0x01 << 3))
//            } else {
//                bytes = (bytes & (~(0x01 << 3)))
//            }
//        }
//    }
//    var flagG: Bool {
//        get {
//            return (((bytes >> 6) & 0x1) != 0)
//        }
//        set {
//            if newValue {
//                bytes = (bytes | (0x01 << 6))
//            } else {
//                bytes = (bytes & (~(0x01 << 6)))
//            }
//        }
//    }
//    var flagH: Bool {
//        get {
//            return (((bytes >> 7) & 0x1) != 0)
//        }
//        set {
//            if newValue {
//                bytes = (bytes | (0x01 << 7))
//            } else {
//                bytes = (bytes & (~(0x01 << 7)))
//            }
//        }
//    }
    
    /*
     位运算抽象方法，避免大量相似代码
     */
    var flagA: Bool {
        get {
            return getIndexBytes(0)
        }
        set {
            actionIndexBytes(0, newValue: newValue)
        }
    }
    var flagB: Bool {
        get {
            return getIndexBytes(1)
        }
        set {
            actionIndexBytes(1, newValue: newValue)
        }
    }
    var flagD: Bool {
        get {
            return getIndexBytes(3)
        }
        set {
            actionIndexBytes(3, newValue: newValue)
        }
    }
    var flagG: Bool {
        get {
            return getIndexBytes(6)
        }
        set {
            actionIndexBytes(6, newValue: newValue)
        }
    }
    var flagH: Bool {
        get {
            return getIndexBytes(7)
        }
        set {
            actionIndexBytes(7, newValue: newValue)
        }
    }
    
    fileprivate func getIndexBytes(_ index: UInt) -> Bool {
        return (((bytes >> index) & 0x1) != 0)
    }
    fileprivate func actionIndexBytes(_ index: UInt, newValue: Bool) {
        if newValue {
            bytes = (bytes | (0x01 << index))
        } else {
            bytes = (bytes & (~(0x01 << index)))
        }
    }
    
    // 同时判断多个条件是否符合要求
    public func isABCD_AllTure() -> Bool {
        return (bytes & 0x0f) >= 0x0f
    }
}


class testBitVC: UIViewController {
    
    var bits = BitsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "BitsVC"
        setupData()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    fileprivate func setupView() {
        
    }
    
    fileprivate func setupData() {
        bits.bytes = 0b11110110
        debugPrint(bits.flagA)
        bits.flagA = true
        debugPrint(bits.flagA, bits.bytes)
//        bits.flagA = true
//        debugPrint(bits.flagA, bits.bytes)
        
        debugPrint(bits.flagD)
        bits.flagD = true
        debugPrint(bits.flagD, bits.bytes)
//        bits.flagD = true
//        debugPrint(bits.flagD, bits.bytes)
        
        debugPrint(bits.flagH)
        bits.flagH = false
        debugPrint(bits.flagH, bits.bytes)
//        bits.flagH = true
//        debugPrint(bits.flagH, bits.bytes)
        
        debugPrint(bits.flagA, bits.flagB, bits.flagD, bits.flagG, bits.flagH, bits.bytes)
        debugPrint(bits.isABCD_AllTure())
    }
    
}
