//
//  testTipVC.swift
//  iosDev
//
//  Created by kingdee on 2024/3/26.
//

import UIKit

class testTipVC: UIViewController {
    
    lazy var topLeftView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    lazy var topRightView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.green
        return view
    }()
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yellow
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "testTipVC"
        setupData()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        topLeftView.showLoading()
        topRightView.showAutoHideAlertMsg("test", offsetY: 50.0, duration: 5.0)
        bottomView.showAutoHideAlertMsg("test abc")
    }
    
    fileprivate func setupView() {
        
        self.navigationController?.navigationBar.isTranslucent = false
        view.addSubview(topLeftView)
        view.addSubview(topRightView)
        view.addSubview(bottomView)
        topLeftView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.right.equalTo(topRightView.snp.left)
            make.height.equalTo(200.0);
            make.size.equalTo(topRightView)
        }
        topRightView.snp.makeConstraints { make in
            make.right.equalToSuperview()
        }
        bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topLeftView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    fileprivate func setupData() {
        
    }
}
