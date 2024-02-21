//
//  testGestureVC.swift
//  iosDev
//
//  Created by kingdee on 2024/2/21.
//

import UIKit

class testGestureVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "testGestureVC"
        setupData()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    fileprivate func setupView() {
        
        let redView = SimpleGestureView()
        redView.name = "red"
        redView.backgroundColor = UIColor.red
        
        let greenView = SimpleGestureView()
        greenView.name = "green"
        greenView.backgroundColor = UIColor.green
        
        view.addSubview(redView)
        redView.addSubview(greenView)
        redView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100.0, height: 100.0))
        }
        greenView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 50.0, height: 50.0))
        }
    }
    
    fileprivate func setupData() {
      
    }
}
