//
//  HHTimerManager.swift
//  ToolBox
//
//  Created by 君若见故 on 2020/5/21.
//  Copyright © 2020 君若见故. All rights reserved.
//

import Foundation

/*
 智能定时器：
 当有人订阅定时器时工作，当无人订阅时挂起；
 订阅者为弱引用存在,无需关心订阅者与定时器间的内存管理问题。
 */
public class HHTimerManager: NSObject {
    
    public typealias timeCallFunc = () -> Void
    // 间隔, 毫秒单位
    public var timeInterval: Int = 1000
    
    class HHTimerObserver {
        weak var observer: AnyObject?
        // 间隔, 秒
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
    
    fileprivate lazy var timerSource: DispatchSourceTimer = {
        let queue = DispatchQueue(label: "dispatchTimerQueue")
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: .now(), repeating: .milliseconds(timeInterval))
        timer.setEventHandler(handler: {[weak self] in
            guard let `self` = self else { return }
            self.timerRepeatCall()
        })
        self.wakeupTimer()
        return timer
    }()
    
    fileprivate let lock: NSLock = NSLock()
    fileprivate lazy var observerList: [HHTimerObserver] = []
    var timerIsRunning: Bool = false
    
    deinit {
        stopTimer()
        debugPrint("HHTimerManager deinit")
    }
    
    fileprivate func checkExistObserver() {
        observerList.removeAll { timerObserver -> Bool in
            guard let _ = timerObserver.observer else {
                return true
            }
            return false
        }
        observerList.count > 0 ? wakeupTimer() : suspendTimer()
    }
    
    fileprivate func timerRepeatCall() {
        self.lock.lock()
        let interval = TimeInterval(timeInterval)/1000.0
        observerList.forEach { timerObserver in
            if let _ = timerObserver.observer {
                timerObserver.intervalCount += interval
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
        self.lock.unlock()
    }
    
    fileprivate func wakeupTimer() {
        if timerIsRunning { return }
        timerIsRunning = true
        timerSource.resume()
//        debugPrint("wakeupTimer...")
    }
    
    fileprivate func suspendTimer() {
        guard timerIsRunning else {
            return
        }
        timerIsRunning = false
        timerSource.suspend()
//        debugPrint("suspendTimer...")
    }
    
    fileprivate func stopTimer() {
        if !timerIsRunning {
            timerSource.resume()
        }
        timerSource.cancel()
    }
}

extension HHTimerManager {
    
    public func addTimerObserver(_ observer: AnyObject, interval: TimeInterval, inQueue: DispatchQueue = DispatchQueue.main, callBack: @escaping timeCallFunc) {
        
        self.lock.lock()
        let timeObserver = HHTimerObserver(observer: observer, interval: interval, callBack: callBack)
        timeObserver.callInQueue = inQueue
        observerList.append(timeObserver)
        checkExistObserver()
        self.lock.unlock()
    }
    
    public func removeTimerObserver(_ observer: AnyObject) {
        
        self.lock.lock()
        observerList.removeAll { timeObserver -> Bool in
            if let obs = timeObserver.observer, obs === observer {
                return true
            }
            return false
        }
        checkExistObserver()
        self.lock.unlock()
    }
}
