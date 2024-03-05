//
//  HHLinkedList.swift
//  iosDev
//
//  Created by kingdee on 2024/3/1.
//

import Foundation

// 单向链表
class SingleLinkListNode {
    
    var value: Int = -1
    var next: SingleLinkListNode? = nil
    
    static func describe(_ head: SingleLinkListNode?) {
        var tempList: [SingleLinkListNode] = []
        var dummy: SingleLinkListNode? = head
        while dummy != nil {
            tempList.append(dummy!)
            dummy = dummy!.next
        }
        let desc = tempList.map { String($0.value) }.joined(separator: "->")
        debugPrint("\(desc)")
    }
}

extension SingleLinkListNode: Equatable {
    
    static func == (lhs: SingleLinkListNode, rhs: SingleLinkListNode) -> Bool {
        return lhs.value == rhs.value
    }
}

// 双向链表
class DoubleLinkListNode {
    
    var value: Int = -1
    var pre: DoubleLinkListNode? = nil
    var next: DoubleLinkListNode? = nil
}
