//
//  testDeviceInfoVC.swift
//  iosDev
//
//  Created by kingdee on 2024/3/26.
//

import Foundation

class testDeviceInfoVC: UIViewController {
    
    lazy var table: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .grouped)
        tb.tableHeaderView = UIView()
        tb.tableFooterView = UIView()
        tb.delegate = self
        tb.dataSource = self
        tb.estimatedRowHeight = 0.0
        tb.estimatedSectionHeaderHeight = 0.0
        tb.estimatedSectionFooterHeight = 0.0
//        tb.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tb
    }()
    
    var dataList: [(name: String, desc: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "testDeviceInfoVC"
        setupData()
        setupView()
    }
    
    deinit {
        debugPrint("testDeviceInfoVC deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        table.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        
        let mbSize = 1024.0 * 1024.0
        let gbSize = 1024.0 * 1024.0 * 1024.0
        let memorySize = Double(UIDevice.getTotalMemorySize()) / mbSize
        let availabelMemorySize = Double(UIDevice.getAvailableMemorySize()) / mbSize
        let appMemorySize = Double(UIDevice.getCurrentAppMemorySize()) / mbSize
        let diskSize = Double(UIDevice.getTotalDiskSize()) / gbSize
        let diskFreeSize = Double(UIDevice.getDiskFreeSize()) / gbSize
        let diskUseSize = Double(UIDevice.getDiskUseSize()) / gbSize
        self.dataList = [("App名称", UIDevice.appName()),
                         ("Bundle Identifier", UIDevice.bundleIdentifier()),
                         ("Build版本号", UIDevice.appBuildVersion()),
                         ("设备序列号", UIDevice.deviceSerialNum()),
                         ("UUID", UIDevice.uuid()),
                         ("设备别名", UIDevice.deviceNameDefineByUser()),
                         ("设备类型", UIDevice.deviceName()),
                         ("系统版本", UIDevice.deviceSystemVersion()),
                         ("设备型号", UIDevice.deviceModel()),
                         ("设备区域型号", UIDevice.deviceLocalModel()),
                         ("电池状态", String(format: "%ld", UIDevice.batteryState().rawValue)),
                         ("电量等级", String(format: "%.1f", UIDevice.batteryLevel())),
                         ("精准电池电量", String(format: "%.2f", UIDevice.getCurrentBatteryLevel())),
                         ("IP地址", UIDevice.getIPAdress()),
                         ("内存大小", String(format: "%.2f MB", memorySize)),
                         ("剩余内存大小", String(format: "%.2f MB", availabelMemorySize)),
                         ("APP占用内存大小", String(format: "%.2f MB", appMemorySize)),
                         ("存储大小", String(format: "%.3f GB", diskSize)),
                         ("已使用存储大小", String(format: "%.3f GB", diskUseSize)),
                         ("剩余存储大小", String(format: "%.3f GB", diskFreeSize)),
                         ("CPU核心数量",  String(format: "%ld", UIDevice.cpuProcessorCount())),
                         ("CPU使用率",  String(format: "%.2f", UIDevice.cpuUsage()))
        ]
    }
}

extension testDeviceInfoVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
        }
        let model = dataList[indexPath.row]
        cell!.textLabel?.text = model.name
        cell!.detailTextLabel?.text = model.desc
        cell!.detailTextLabel?.adjustsFontSizeToFitWidth = true
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
