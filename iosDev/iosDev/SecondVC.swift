//
//  SecondVC.swift
//  iosDev
//
//  Created by kingdee on 2024/1/5.
//

import UIKit

// 主要是工具类的测试验证
class SecondVC: UIViewController {
    
    lazy var table: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .grouped)
        tb.tableHeaderView = UIView()
        tb.tableFooterView = UIView()
        tb.delegate = self
        tb.dataSource = self
        tb.estimatedRowHeight = 0.0
        tb.estimatedSectionHeaderHeight = 0.0
        tb.estimatedSectionFooterHeight = 0.0
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tb
    }()
    
    var dataList: [(name: String, action: ()->Void)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupData()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        table.reloadData()
    }
    
    fileprivate func setupView() {
        view.addSubview(table)
        table.contentInsetAdjustmentBehavior = .never
        table.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp_topMargin)
            make.bottom.equalTo(self.view.snp_bottomMargin)
            make.left.right.equalToSuperview()
        }
    }
    
    fileprivate func setupData() {
        dataList.append(("simpleOperation", {[weak self] in
            let simpleOperationVC = testSimpleOperationVC()
            self?.navigationController?.pushViewController(simpleOperationVC, animated: true)
        }))
        dataList.append(("smartTimer", {[weak self] in
            let timerVC = testTimerVC()
            self?.navigationController?.pushViewController(timerVC, animated: true)
        }))
        dataList.append(("UIDevice Category", {[weak self] in
            let deviceInfoVC = testDeviceInfoVC()
            self?.navigationController?.pushViewController(deviceInfoVC, animated: true)
        }))
        
    }
}

extension SecondVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = dataList[indexPath.row]
        cell.textLabel?.text = model.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataList[indexPath.row]
        model.action()
    }
}
