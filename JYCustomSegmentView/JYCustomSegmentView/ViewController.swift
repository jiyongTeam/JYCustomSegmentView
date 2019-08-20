//
//  ViewController.swift
//  JYCustomSegmentView
//
//  Created by admin on 2019/8/20.
//  Copyright © 2019 Phz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let topView = JYCustomSegmentView(dataSource:["测试1","测试2","测试3","测试4","测试5","测试6","测试7","测试8"],itemType: .defaultType,scrollType: .centerType)
    let topView2 = JYCustomSegmentView(dataSource:["测试1","测试2","测试3","测试4","测试5","测试6","测试7","测试8"],itemType: .equalScreenType,lineViewType: .defaultLineType)
    let topView3 = JYCustomSegmentView(dataSource:nil,itemType: .fixedWidthType,lineViewType: .autoWidthLineType)
    let contentView = JYSegmentContentView()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configerUI()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        topView3.reloadSegmentDatas(dataSource: ["测试1","测试2","测试3","测试4","测试5","测试6","测试7","测试8"])
        topView.reloadSegmentDatas(dataSource: ["测试1","测试2","测试3","测试4","测试5","测试6","测试7","测试8"])
        topView2.reloadSegmentDatas(dataSource: ["测试1","测试2","测试3","测试4","测试5","测试6","测试7","测试8"])
        topView3.selectIndex = 3
        topView3.itemStyle = JYSegmentItemStyle(barHeight: 60, textNormalColor: UIColor.black, textNormalFont: UIFont.systemFont(ofSize: 15),textSelectColor: UIColor.magenta,textSelectFont: UIFont.systemFont(ofSize: 22, weight: .semibold), itemWidth: 100, itemSpacing: 20, lineViewHeight: 2, lineViewColor: UIColor.red, lineViewLayer: nil)
        let arr:[UIViewController] = [JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC()]
        contentView.addControllersToContentView(superController: self, controllers: arr)
    }

    private func configerUI() {
        topView.segmentDelegate = self
        topView2.segmentDelegate = self
        topView3.segmentDelegate = self
        contentView.pageViewDelegate = self
        self.view.addSubview(topView)
        self.view.addSubview(topView2)
        self.view.addSubview(topView3)
        self.view.addSubview(contentView)
        let vd:[String:UIView] = ["topView":topView,"topView2":topView2,"topView3":topView3,"contentView":contentView]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[topView]|", options: [], metrics: nil, views: vd))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[topView(60)]-10-[topView2(60)]-10-[topView3(50)][contentView]", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: vd))
        if #available(iOS 11.0, *) {
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        } else {
            topView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        }
    }
}

extension ViewController : JYCustomizeSegmentDelegate,JYSegmentContentViewDelegate {
    
    func scrollViewDeceleratingAction(currentIndex: Int) {
        debugPrint(currentIndex)
        topView3.updateSelectIndex(currentIndex: currentIndex)
    }
    
    func didSelectSegmentItem(in segmentView: JYCustomSegmentView, selectIndex: Int) {
        debugPrint(selectIndex)
        contentView.resetScrollerViewContentOffSet(selectIndex: selectIndex)
    }
}
