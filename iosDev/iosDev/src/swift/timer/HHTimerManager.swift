//
//  HHTimerManager.swift
//  ToolBox
//
//  Created by 君若见故 on 2020/5/21.
//  Copyright © 2020 君若见故. All rights reserved.
//

import Foundation

let timeInterval = 1.0
let tolerance = 0.0
/*
 智能定时器：
 当有人订阅定时器时工作，当无人订阅时挂起；
 订阅者为弱引用存在,无需关心订阅者与定时器间的内存管理问题。
 */
public class HHTimerManager: NSObject {
    
    public typealias timeCallFunc = () -> Void
    
    class HHTimerObserver {
        weak var observer: AnyObject?
        var interval: TimeInterval
        var intervalCount: TimeInterval
        var callBackFunc: timeCallFunc
        var callInQueue: DispatchQueue?
        
        init(observer: AnyObject, interval: TimeInterval, callBack: @escaping timeCallFunc) {
            self.observer = observer
            self.interval = interval
            self.intervalCount = 0.0
            self.callBackFunc = callBack
        }
    }
    
    fileprivate lazy var timer: Timer = {
        let timer = Timer(timeInterval: timeInterval, repeats: true) {[weak self] _ in
            guard let `self` = self else { return }
            self.timerRepeatCall()
        }
        timer.tolerance = tolerance
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        return timer
    }()
    fileprivate lazy var observerList: [HHTimerObserver] = []
    var timerIsRunning: Bool = false
    
    deinit {
        debugPrint("HHTimerManager deinit")
    }
    
    fileprivate func checkExistObserver() {
        synchronized(self) {
            observerList.removeAll { timerObserver -> Bool in
                guard let _ = timerObserver.observer else {
                    return true
                }
                return false
            }
            observerList.count > 0 ? wakeupTimer() : suspendTimer()
        }
    }
    
    fileprivate func timerRepeatCall() {
        synchronized(self) {
            observerList.forEach { timerObserver in
                if let _ = timerObserver.observer {
                    timerObserver.intervalCount += timeInterval
                    if timerObserver.intervalCount >= timerObserver.interval {
                        timerObserver.intervalCount = 0.0
                        if let queue = timerObserver.callInQueue {
                            queue.async {
                                if let _ = timerObserver.observer {
                                    timerObserver.callBackFunc()
                                }
                            }
                        } else {
                            timerObserver.callBackFunc()
                        }
                    }
                }
            }
            checkExistObserver()
        }
    }
    
    fileprivate func wakeupTimer() {
        if timerIsRunning { return }
        timerIsRunning = true
//        timer.fireDate = Date.distantPast
        timer.fireDate = Date.init(timeInterval: timeInterval, since: Date())
//        debugPrint("wakeupTimer...")
    }
    
    fileprivate func suspendTimer() {
        guard timerIsRunning else {
            return
        }
        timerIsRunning = false
        timer.fireDate = Date.distantFuture
//        debugPrint("suspendTimer...")
    }
    
    fileprivate func stopTimer() {
        timerIsRunning = false
        timer.invalidate()
    }
}

extension HHTimerManager {
    
    public func addTimerObserver(_ observer: AnyObject, interval: TimeInterval, inQueue: DispatchQueue = DispatchQueue.main, callBack: @escaping timeCallFunc) {
        
        synchronized(self) {
            let timeObserver = HHTimerObserver(observer: observer, interval: interval, callBack: callBack)
            if inQueue != DispatchQueue.main {
                timeObserver.callInQueue = inQueue
            }
            observerList.append(timeObserver)
        }
        checkExistObserver()
    }
    
    public func removeTimerObserver(_ observer: AnyObject) {
        
        synchronized(self) {
            observerList.removeAll { timeObserver -> Bool in
                if let obs = timeObserver.observer, obs === observer {
                    return true
                }
                return false
            }
        }
        checkExistObserver()
    }
}
