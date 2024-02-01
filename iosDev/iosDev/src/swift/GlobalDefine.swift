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

public func synchronized<T>(_ lock: AnyObject, _ closure: () throws -> T) rethrows -> T {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    return try closure()
}
