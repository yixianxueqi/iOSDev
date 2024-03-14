//
//  testQueueVC.swift
//  iosDev
//
//  Created by kingdee on 2024/3/14.
//

import UIKit

class testQueueVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "testQueueVC"
        setupData()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    fileprivate func setupView() {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.systemBlue
        btn.setTitle("OC Queue", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(toOCVC), for: .touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp_topMargin).offset(8.0)
            make.left.right.equalToSuperview()
            make.height.equalTo(44.0)
        }
    }
    
    fileprivate func setupData() {
        
    }
    
    @objc fileprivate func toOCVC() {
        let vc = testQueueOCViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
