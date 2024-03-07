//
//  HHBinaryTree.swift
//  iosDev
//
//  Created by kingdee on 2024/3/6.
//

import Foundation

// 二叉树
class BinaryTree {
    
    var value = -1
    var letf: BinaryTree?
    var right: BinaryTree?
    
    init() {}
    
    convenience init(value: Int = -1, letf: BinaryTree? = nil, right: BinaryTree? = nil) {
        self.init()
        self.value = value
        self.letf = letf
        self.right = right
    }
    
    //先序遍历
    static func pre(head: BinaryTree?) {
        guard let head = head else { return }
        
        debugPrint("\(head.value)")
        pre(head: head.letf)
        pre(head: head.right)
    }
    
    //中序遍历
    static func mid(head: BinaryTree?) {
        guard let head = head else { return }
        
        mid(head: head.letf)
        debugPrint("\(head.value)")
        mid(head: head.right)
    }
    
    //后序遍历
    static func post(head: BinaryTree?) {
        guard let head = head else { return }
        
        post(head: head.letf)
        post(head: head.right)
        debugPrint("\(head.value)")
    }
}

extension BinaryTree: Equatable {
    
    static func == (lhs: BinaryTree, rhs: BinaryTree) -> Bool {
        return lhs.value == rhs.value
    }
}
