//
//  SimpleGestureView.swift
//  iosDev
//
//  Created by kingdee on 2024/2/21.
//

import UIKit

class SimpleGestureView: UIView {
    
    var name: String = ""
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
        debugPrint("\(name) touchesBegan")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesMoved(touches, with: event)
        debugPrint("\(name) touchesMoved")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesCancelled(touches, with: event)
        debugPrint("\(name) touchesCancelled")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
        debugPrint("\(name) touchesEnded")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        debugPrint("\(name) point inside")
        return super.point(inside: point, with: event)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        debugPrint("\(name) hitTest")
        return super.hitTest(point, with: event)
    }
}
