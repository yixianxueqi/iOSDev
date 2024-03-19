//
//  LCGoldenAlgorithm.swift
//  iosDev
//
//  Created by kingdee on 2024/3/7.
//

import Foundation

class LCGoldenAlgorithm {
    
    static func show() {
        
        let su = Solution()
        debugPrint("\(su.isUnique("leetcode"))")
        debugPrint("\(su.CheckPermutation("abc", "bca"))")
        debugPrint("\(su.replaceSpaces("Mr John Smith    ", 13))")
        debugPrint("\(su.canPermutePalindrome("tactcoa"))")
        debugPrint("\(su.oneEditAway("pale", "ple"))")
        debugPrint("\(su.compressString("aabcccccaaa"))")
        debugPrint("\(su.isFlipedString("waterbottle", "erbottlewat"))")
        
    }
    
}

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

class Solution {}

extension Solution {
    /*
     01.01 实现一个算法，确定一个字符串 s 的所有字符是否全都不同。

     示例 1：

     输入: s = "leetcode"
     输出: false
     示例 2：

     输入: s = "abc"
     输出: true
     限制：

     0 <= len(s) <= 100
     s[i]仅包含小写字母
     如果你不使用额外的数据结构，会很加分。
     */
    func isUnique(_ astr: String) -> Bool {
        var str = astr
        for i in str {
            str.removeFirst()
            if str.contains(i) {
                return false
            }
        }
        return true
    }
}

extension Solution {
    /*
     01.02 给定两个由小写字母组成的字符串 s1 和 s2，请编写一个程序，确定其中一个字符串的字符重新排列后，能否变成另一个字符串。

     示例 1：

     输入: s1 = "abc", s2 = "bca"
     输出: true
     示例 2：

     输入: s1 = "abc", s2 = "bad"
     输出: false
     说明：

     0 <= len(s1) <= 100
     0 <= len(s2) <= 100
     */
    func CheckPermutation(_ s1: String, _ s2: String) -> Bool {
        var s1 = s1, s2 = s2
        if s1.count != s2.count {
            return false
        }
        var flag = true
        while s1.count > 0 {
            let temp = s1.removeFirst()
            if let index = s2.firstIndex(of: temp) {
                s2.remove(at: index)
            } else {
                flag = false
                break
            }
        }
        return flag
    }
    
}

extension Solution {
    /*
     01.03 URL化。编写一种方法，将字符串中的空格全部替换为%20。假定该字符串尾部有足够的空间存放新增字符，并且知道字符串的“真实”长度。（注：用Java实现的话，请使用字符数组实现，以便直接在数组上操作。）

     示例 1：

     输入："Mr John Smith    ", 13
     输出："Mr%20John%20Smith"
     示例 2：

     输入："               ", 5
     输出："%20%20%20%20%20"
      

     提示：

     字符串长度在 [0, 500000] 范围内。
     */
    func replaceSpaces(_ S: String, _ length: Int) -> String {
        var res: String = ""
        var cur = 0
        for ch in S {
            if cur == length { break }
            if String(ch) == " " {
                res += "%20"
            } else {
                res += String(ch)
            }
             cur += 1
        }
        return res
    }
}

extension Solution {
    
    /*
     01.04
     给定一个字符串，编写一个函数判定其是否为某个回文串的排列之一。

     回文串是指正反两个方向都一样的单词或短语。排列是指字母的重新排列。

     回文串不一定是字典当中的单词。

      

     示例1：

     输入："tactcoa"
     输出：true（排列有"tacocat"、"atcocta"，等等）
     */
    func canPermutePalindrome(_ s: String) -> Bool {
        var dictionary = [Character: Int]()
        s.forEach { dictionary[$0, default: 0] += 1 }
        return dictionary.filter { $0.value % 2 != 0 }.count < 2
    }
}

extension Solution {
    
    /*
     01.05
     字符串有三种编辑操作:插入一个英文字符、删除一个英文字符或者替换一个英文字符。 给定两个字符串，编写一个函数判定它们是否只需要一次(或者零次)编辑。

      

     示例 1:

     输入:
     first = "pale"
     second = "ple"
     输出: True
      

     示例 2:

     输入:
     first = "pales"
     second = "pal"
     输出: False
     */
    func oneEditAway(_ first: String, _ second: String) -> Bool {
        if first == second {
            return true
        }
        if abs(first.count - second.count) > 1 {
            return false
        }
        var i = 0
        var j = 0
        var offset = 0
        var count = 0
        let firstStr: String = (first.count < second.count ? first : second)
        let secondStr: String = (first.count < second.count ? second : first)
        let countSame = (firstStr.count == secondStr.count)
        for _ in 0..<firstStr.count {
            let c1 = firstStr[firstStr.index(firstStr.startIndex, offsetBy: i)]
            var c2 = secondStr[secondStr.index(secondStr.startIndex, offsetBy: j+offset)]
            if c1 != c2 {
                if countSame {
                    count += 1
                    if count > 1 {
                        return false
                    }
                } else {
                    offset += 1
                    if offset > 1  {
                        return false
                    }
                    c2 = secondStr[secondStr.index(secondStr.startIndex, offsetBy: j+offset)]
                    if c1 != c2 {
                        return false
                    }
                }
            }
            i += 1
            j += 1
        }
        return true
    }
}

extension Solution {
    
    /*
     01.06
     字符串压缩。利用字符重复出现的次数，编写一种方法，实现基本的字符串压缩功能。比如，字符串aabcccccaaa会变为a2b1c5a3。若“压缩”后的字符串没有变短，则返回原先的字符串。你可以假设字符串中只包含大小写英文字母（a至z）。

     示例1:

      输入："aabcccccaaa"
      输出："a2b1c5a3"
     示例2:

      输入："abbccd"
      输出："abbccd"
      解释："abbccd"压缩后为"a1b2c2d1"，比原字符串长度更长。
     提示：

     字符串长度在[0, 50000]范围内。
     */
    func compressString(_ S: String) -> String {
        if S.count <= 2 { return S }
        var cpsStr = ""
        var count = 0
        for i in S {
            if i == cpsStr.last {
                count += 1
            } else {
                if count > 0 {
                    cpsStr.append("\(count)")
                }
                cpsStr.append(i)
                count = 1
            }
        }
        if count > 0 {
            cpsStr.append("\(count)")
        }
        if cpsStr.count >= S.count {
            cpsStr = S
        }
        return cpsStr
    }
}

extension Solution {
    
    /*
     01.09
     字符串轮转。给定两个字符串s1和s2，请编写代码检查s2是否为s1旋转而成（比如，waterbottle是erbottlewat旋转后的字符串）。

     示例1:

      输入：s1 = "waterbottle", s2 = "erbottlewat"
      输出：True
     示例2:

      输入：s1 = "aa", s2 = "aba"
      输出：False
     提示：

     字符串长度在[0, 100000]范围内。
     说明:

     你能只调用一次检查子串的方法吗？
     */
    func isFlipedString(_ s1: String, _ s2: String) -> Bool {
        if s1.count != s2.count { return false }
        if s1 == s2 {return true}
        var s1_s1 = s1 + s1
        return s1_s1.contains(s2)
    }
}

extension Solution {
    
    /*
     02.01
     编写代码，移除未排序链表中的重复节点。保留最开始出现的节点。

     示例1:

      输入：[1, 2, 3, 3, 2, 1]
      输出：[1, 2, 3]
     示例2:

      输入：[1, 1, 1, 1, 2]
      输出：[1, 2]
     提示：

     链表长度在[0, 20000]范围内。
     链表元素在[0, 20000]范围内。
     进阶：

     如果不得使用临时缓冲区，该怎么解决？
     */
    func removeDuplicateNodes(_ head: ListNode?) -> ListNode? {
        if head == nil || head?.next == nil {
            return head
        }
        var temp = head
        var map: [Int: Bool] = [temp!.val: true]
        
        while temp?.next != nil {
            if let _ = map[temp!.next!.val] {
                temp?.next = temp?.next?.next
            }else{
                map[temp!.next!.val] = true
                temp = temp?.next
            }
        }
        return head
    }
}

extension Solution {
    /*
     02.02
     返回倒数第 k 个节点
     
     实现一种算法，找出单向链表中倒数第 k 个节点。返回该节点的值。

     注意：本题相对原题稍作改动

     示例：

     输入： 1->2->3->4->5 和 k = 2
     输出： 4
     说明：

     给定的 k 保证是有效的。
     */
    func kthToLast(_ head: ListNode?, _ k: Int) -> Int {
        var pFront = head
        var pEnd = head
        for _ in 0..<k {
            pEnd = pEnd?.next
        }
        while pEnd != nil {
            pFront = pFront?.next
            pEnd = pEnd?.next
        }
        return pFront?.val ?? 0
    }
}
