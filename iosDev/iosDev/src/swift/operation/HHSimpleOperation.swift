//
//  HHSimpleOperation.swift
//  iosDev
//
//  Created by kingdee on 2024/1/31.
//

import Foundation

private let kCancelledKey = "isCancelled"
private let kExecutingdKey = "isExecuting"
private let kFinshedKey = "isFinished"
// 包装的简易Operation，可用于并发的简单控制；复杂的还需自定义
@objcMembers class HHSimpleOperation: Operation {
    
    var actionBlock: ((@escaping ()->Void)->Void)?
    var cancelBlock: (()->Void)?
    var finshBlock: (()->Void)?
    
    fileprivate var _cancel: Bool = false {
        willSet {
            self.willChangeValue(forKey: kCancelledKey)
        }
        didSet {
            self.didChangeValue(forKey: kCancelledKey)
        }
    }
    fileprivate var _executing: Bool = false {
        willSet {
            self.willChangeValue(forKey: kExecutingdKey)
        }
        didSet {
            self.didChangeValue(forKey: kExecutingdKey)
        }
    }
    fileprivate var _finished: Bool = false {
        willSet {
            self.willChangeValue(forKey: kFinshedKey)
        }
        didSet {
            self.didChangeValue(forKey: kFinshedKey)
        }
    }
    public override var isCancelled: Bool {
        return _cancel
    }
    public override var isExecuting: Bool {
        return _executing
    }
    public override var isFinished: Bool {
        return _finished
    }
    
    override init() {
        super.init()
    }
    
    deinit {
        debugPrint("HHSimpleOperation deinit...")
    }
    
    public override func cancel() {
        _cancel = true
        self.cancelBlock?()
        self.finshBlock?()
    }
    
    public override func start() {
        if _cancel {
            completion()
        }else {
            _executing = true
            let finshCall: ()->Void = {[weak self] in
                self?.completion()
            }
            self.actionBlock?(finshCall)
        }
    }
    
    fileprivate func completion() {
        _executing = false
        _finished = true
        self.finshBlock?()
    }
    
}
//包装的简易OperationQueue, 可快速添加任务 及 管理任务依赖等；
@objcMembers class HHSimpleOperationManager: NSObject {
    
    fileprivate var maxConcurrentOperationCount = 1
    fileprivate var underlyingQueue: dispatch_queue_t?
    
    convenience init(maxConcurrentOperationCount: Int = 1) {
        self.init()
        self.maxConcurrentOperationCount = maxConcurrentOperationCount
    }
    
    private override init() {
        super.init()
    }
    
    deinit {
        debugPrint("KDUniversalSimpleOptrionManager dealloc...")
    }
    
    lazy var operationQueue: OperationQueue = {
        let operationQue = OperationQueue()
        operationQue.name = "HHSimpleOperationQueue"
        operationQue.maxConcurrentOperationCount = maxConcurrentOperationCount
        if maxConcurrentOperationCount > 1 {
            self.underlyingQueue = DispatchQueue.init(label: "",
                                                              qos: .default,
                                                              attributes: .concurrent,
                                                              autoreleaseFrequency: . workItem,
                                                              target: nil)
        } else {
            self.underlyingQueue = DispatchQueue(label: "")
        }
        operationQue.underlyingQueue = self.underlyingQueue
        operationQue.qualityOfService = .default
        return operationQue
    }()
    
    public func addOperationTask(with operation: Operation) {
        self.operationQueue.addOperation(operation)
    }
    
    public func addOperationTask(with action: @escaping (@escaping ()->Void)->Void, cancel:(()->Void)? = {}, finsh:(()->Void)? = {}) {
        let operation = HHSimpleOperation()
        operation.actionBlock = action
        operation.cancelBlock = cancel
        operation.finshBlock = finsh
        self.operationQueue.addOperation(operation)
    }
}
