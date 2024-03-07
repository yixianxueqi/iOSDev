//
//  MainVC.swift
//  iosDev
//
//  Created by kingdee on 2024/1/5.
//

import UIKit

// 主要是UI相关的测试验证
class MainVC: UIViewController {
    
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
        dataList.append(("testGestureVC", {[weak self] in
            let testGestureVC = testGestureVC()
            self?.navigationController?.pushViewController(testGestureVC, animated: true)
        }))
    }
    
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
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
