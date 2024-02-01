//
//  testSimpleOperationVC.swift
//  iosDev
//
//  Created by kingdee on 2024/2/1.
//

import UIKit

class testSimpleOperationVC: UIViewController {
    
    lazy var conOperationManager: HHSimpleOperationManager = {
        let mgr = HHSimpleOperationManager(maxConcurrentOperationCount: 2)
        return mgr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "testSimpleOperationVC"
        setupData()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    fileprivate func setupView() {
        
    }
    
    fileprivate func setupData() {
        
        debugPrint("task group start")
        // task 1
        conOperationManager.addOperationTask { callback in
            debugPrint("task1 start")
            delay(2.0) {
                debugPrint("task1 end")
                callback()
            }
        } cancel: {
            debugPrint("task1 cancel")
        } finsh: {
            debugPrint("task1 finsh")
        }
        
        // task 2
        conOperationManager.addOperationTask { callback in
            debugPrint("task2 start")
            delay(3.0) {
                debugPrint("task2 end")
                callback()
            }
        } cancel: {
            debugPrint("task2 cancel")
        } finsh: {[weak self] in
            debugPrint("task2 finsh")
            self?.conOperationManager.operationQueue.cancelAllOperations()
        }
        
        // task 3
        conOperationManager.addOperationTask { callback in
            debugPrint("task3 start")
            delay(4.0) {
                debugPrint("task3 end")
                callback()
            }
        } cancel: {
            debugPrint("task3 cancel")
        } finsh: {
            debugPrint("task3 finsh")
        }
        
        debugPrint("task group end")
    }
}
