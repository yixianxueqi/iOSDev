//
//  GlobalDefine.swift
//  iosDev
//
//  Created by kingdee on 2024/1/5.
//

import Foundation

public func delay(_ delay:Double, _ closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + delay, execute: closure)
}
