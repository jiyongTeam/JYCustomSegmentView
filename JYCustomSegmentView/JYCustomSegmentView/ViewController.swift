//
//  ViewController.swift
//  JYCustomSegmentView
//
//  Created by admin on 2019/8/20.
//  Copyright © 2019 Phz. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    private lazy var tableView:UITableView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.translatesAutoresizingMaskIntoConstraints = false
        tab.delegate = self
        tab.dataSource = self
        tab.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cellID")
        return tab
    }()
    private let dataArray = ["静态数据源示例","动态数据源示例","继承于JYBaseSegmentController示例"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configrUI()
    }
}

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = StaicDataSourceController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = DynamicDataSourceController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = CustomerViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController {
    
    private func configrUI() {
        self.view.addSubview(tableView)
        let vd:[String:UIView] = ["tableView":tableView]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[tableView]|", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: vd))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[tableView]", options: [], metrics: nil, views: vd))
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
}
