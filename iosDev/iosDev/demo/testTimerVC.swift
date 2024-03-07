//
//  testTimerVC.swift
//  iosDev
//
//  Created by kingdee on 2024/2/1.
//

import UIKit

class testTimerVC: UIViewController {
    
    let smartTimer = HHTimerManager()
    
    var obj1: NSObject? = NSObject()
    var obj2: NSObject? = NSObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "testTimerVC"
        setupData()
        setupView()
    }
    
    deinit {
        debugPrint("testTimerVC deinit")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    fileprivate func setupView() {
        
    }
    
    fileprivate func setupData() {
        
        DispatchQueue.global().async {[weak self] in
            guard let `self` = self else { return }
            self.smartTimer.addTimerObserver(self.obj1!, interval: 2.0) {
                print("obj1...\(Thread.main)")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {[weak self] in
                guard let `self` = self else { return }
                self.obj1 = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {[weak self] in
                    guard let `self` = self else { return }
                    self.smartTimer.addTimerObserver(self.obj2!, interval: 3.0, inQueue: DispatchQueue.global()) {
                        print("obj2...\(Thread.main)")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {[weak self] in
                        guard let `self` = self else { return }
                        self.obj2 = nil
                        self.smartTimer.removeTimerObserver(self)
                    }
                }
            }
        }
        self.smartTimer.addTimerObserver(self, interval: 1.0) {
            print("testTimerVC...")
        }
    }
}
