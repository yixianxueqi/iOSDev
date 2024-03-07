//
//  testAlgorithmVC.swift
//  iosDev
//
//  Created by kingdee on 2024/3/1.
//

import Foundation

class testAlgorithmVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "testAlgorithmVC"
        setupData()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 单链表
//        testReverseLinkList()
//        testMiddleLinkList()
//        mergeTwoSortedLinkList()
//        reverseRangeLinkList()
//        findLinkListHasCycle()
//        findLinkListCycleFirstNode()
        
        // 排序
//        maopaoSort()
//        selectSort()
        
        // 二叉树
        let head = constructBinarytree()
        previewTree(head)
    }
    
    fileprivate func setupView() {
        
    }
    
    fileprivate func setupData() {
        
    }
    
}

// 排序
extension testAlgorithmVC {
    
    // 冒泡排序
    fileprivate func maopaoSort() {
        var list = [1, 5, 3, 9, 7]
        let length = list.count
        for i in 0..<length {
            for j in 0..<(length - i - 1) {
                if list[j] > list[j+1] {
                    let temp = list[j+1]
                    list[j+1] = list[j]
                    list[j] = temp
                }
            }
        }
        debugPrint("\(list)")
    }
    
    // 选择排序
    fileprivate func selectSort() {
        var list = [1, 5, 3, 9, 7]
        let length = list.count
        for i in 0..<(length - 1) {
            var min = i
            for j in (i + 1)..<length {
                if list[min] > list[j] {
                    min = j
                }
            }
            if i != min {
                let temp = list[i]
                list[i] = list[min]
                list[min] = temp
            }
        }
        debugPrint("\(list)")
    }
}

// 链表
extension testAlgorithmVC {
    
    fileprivate func constructLinkList(with list: [Int]) -> SingleLinkListNode? {
        // 构造链表
        var head: SingleLinkListNode? = nil
        var pre: SingleLinkListNode? = nil
        for val in list {
            let node = SingleLinkListNode()
            node.value = val
            if let pre = pre {
                pre.next = node
            } else {
                head = node
            }
            pre = node
        }
        // 查看
        SingleLinkListNode.describe(head)
        return head
    }
    
    // 单项列表逆转
    fileprivate func testReverseLinkList() {
        let head = constructLinkList(with: [1, 2, 3, 4, 5])
        var pre: SingleLinkListNode?
        var next: SingleLinkListNode?
        var dummy = head
        while dummy != nil {
            next = dummy!.next
            dummy!.next = pre
            pre = dummy
            if let _ = next {
                dummy = next
            } else {
                // 没有下一个、结束了
                break
            }
        }
        SingleLinkListNode.describe(dummy)
    }
    
    // 找出中间节点
    fileprivate func testMiddleLinkList() {
//        let head = constructLinkList(with: [1, 2, 3, 4, 5])
        let head = constructLinkList(with: [1, 2, 3, 4, 5, 6])
        var slow = head
        var fast = head
        if head == nil {
            debugPrint("testMiddleLinkList: nil")
        }
        while fast != nil && fast?.next != nil {
            fast = fast?.next?.next
            slow = slow?.next
        }
        debugPrint(slow!.value)
    }
    
    // 合并两个有序链表
    fileprivate func mergeTwoSortedLinkList() {
        let head1 = constructLinkList(with: [1, 3, 5, 7, 9])
        let head2 = constructLinkList(with: [2, 4, 6])
        if head1 == nil {
            SingleLinkListNode.describe(head2)
            return
        } else if head2 == nil {
            SingleLinkListNode.describe(head1)
            return
        }
        var newHead = SingleLinkListNode()
        var newtail = newHead
        var dummy1 = head1
        var dummy2 = head2
        
        while dummy1 != nil && dummy2 != nil {
            if dummy1!.value <= dummy2!.value {
                newtail.next = dummy1
                newtail = newtail.next!
                dummy1 = dummy1?.next
            } else {
                newtail.next = dummy2
                newtail = newtail.next!
                dummy2 = dummy2?.next
            }
        }
        if dummy1 != nil {
            newtail.next = dummy1
        } else if dummy2 != nil {
            newtail.next = dummy2
        }
        // 去除第一个初始化的空节点
        newHead = newHead.next!
        SingleLinkListNode.describe(newHead)
    }
    
    // 翻转链表指定位置
    fileprivate func reverseRangeLinkList() {
        let head = constructLinkList(with: [1, 2, 3, 4, 5, 6, 7])
        let from = 3
        let to = 5
        
        var dummy = head
        // 被翻转链的头尾节点
        var subHead: SingleLinkListNode?
        var subTail: SingleLinkListNode?
        // 原链被断开的前后节点
        var prefixTail: SingleLinkListNode?
        var suffixHead: SingleLinkListNode?
        var index = 0
        while dummy != nil {
            index += 1
            if index == from {
                subHead = dummy
            } else if index == to {
                subTail = dummy
                suffixHead = subTail?.next
                subTail?.next = nil
                break
            }
            if subHead == nil {
                prefixTail = dummy
            }
            dummy = dummy?.next
        }
        
        func reverse(_ head: SingleLinkListNode?) -> SingleLinkListNode? {
            var pre: SingleLinkListNode?
            var next: SingleLinkListNode?
            var dummy = head
            while dummy != nil {
                next = dummy!.next
                dummy!.next = pre
                pre = dummy
                if let _ = next {
                    dummy = next
                } else {
                    // 没有下一个、结束了
                    break
                }
            }
            return dummy
        }
        subHead = reverse(subHead)
        prefixTail?.next = subHead
        while subHead?.next != nil {
            subHead = subHead?.next
        }
        subHead?.next = suffixHead
        SingleLinkListNode.describe(head)
    }
    
    // 检测是否有环
    fileprivate func findLinkListHasCycle() {
        let head = constructLinkList(with: [1, 2, 3, 4, 5, 6, 7, 8, 9])
        let length = 9
        // 制造环
        var tail: SingleLinkListNode? = head
        var cycleNode: SingleLinkListNode?
        let cycleIndex = 4
        for i in 0..<length - 1 {
            if i == cycleIndex {
                cycleNode = tail
            }
            tail = tail?.next
        }
        tail?.next = cycleNode
        //        debugPrint("\(tail)")
        
        // 处理
        var slow: SingleLinkListNode? = head
        var fast: SingleLinkListNode? = head
        var flag = false
        while fast != nil && fast?.next != nil {
            slow = slow?.next
            fast = fast?.next?.next
            if fast == slow || fast?.next == slow {
                flag = true
                break
            }
        }
        debugPrint(flag ? "有环" : "无环")
        
    }
    
    // 找出环的第一个节点
    fileprivate func findLinkListCycleFirstNode() {
        
        let head = constructLinkList(with: [1, 2, 3, 4, 5, 6, 7, 8, 9])
        let length = 9
        // 制造环
        var tail: SingleLinkListNode? = head
        var cycleNode: SingleLinkListNode?
        let cycleIndex = 4
        for i in 0..<length - 1 {
            if i == cycleIndex {
                cycleNode = tail
            }
            tail = tail?.next
        }
        tail?.next = cycleNode
        //        debugPrint("\(tail)")
        
        // 处理
        var slow: SingleLinkListNode? = head
        var fast: SingleLinkListNode? = head
        var flag = false
        while fast != nil && fast?.next != nil {
            slow = slow?.next
            fast = fast?.next?.next
            if fast == slow {
                flag = true
                break
            }
        }
        debugPrint(flag ? "有环" : "无环")
        // 找出入环点
        fast = head;
        var entryCycleNode: SingleLinkListNode?
        while(slow != nil) {
            if slow == fast {
                entryCycleNode = slow
                break
            }
            slow = slow?.next;
            fast = fast?.next;
        }
        debugPrint("\(entryCycleNode?.value)")
    }
}

// 二叉树
extension testAlgorithmVC {
        
    fileprivate func constructBinarytree() -> BinaryTree? {
        /*
         1
         2 3
         4 5 6 7
         */
        var head: BinaryTree? = BinaryTree(value: 1)
        let left1 = BinaryTree(value: 2)
        let right1 = BinaryTree(value: 3)
        head?.letf = left1
        head?.right = right1
        let left2 = BinaryTree(value:4)
        let right2 = BinaryTree(value: 5)
        left1.letf = left2
        left1.right = right2
        let left3 = BinaryTree(value: 6)
        let right3 = BinaryTree(value: 7)
        right1.letf = left3
        right1.right = right3
        return head
    }
    
    fileprivate func previewTree(_ head: BinaryTree?) {
        BinaryTree.pre(head: head)
        debugPrint("------")
        BinaryTree.mid(head: head)
        debugPrint("------")
        BinaryTree.post(head: head)
    }
    
}
