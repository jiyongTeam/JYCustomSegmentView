//
//  ViewController.swift
//  JYCustomSegmentView
//
//  Created by admin on 2019/8/20.
//  Copyright © 2019 Phz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var topView = JYCustomSegmentView(itemType: .defaultType, lineViewType: .autoWidthLineType, scrollType: .centerType)
    let contentView = JYSegmentContentView()
    var datas:[String] = ["测试1","测试2","测试3","测试4","测试5","测试6","明天天气很晴朗","限速","名义","天气","下雨","晴天霹雳"]
    let arr:[UIViewController] = [JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC()]
//    var datas:[String] = ["测试1","测试2","测试3","测试4"]
//    let arr:[UIViewController] = [JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC()]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configerUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        topView.reloadSegmentDatas()
        contentView.addControllersToContentView(superController: self, controllers: arr)
    }

    private func configerUI() {
//        let caLayer = CAGradientLayer()
//        caLayer.colors = [UIColor.red.cgColor,UIColor.green.cgColor]
//        caLayer.locations = [0,1]
////        caLayer.startPoint = CGPoint(x: 0, y: 0)
////        caLayer.endPoint = CGPoint(x: 1, y: 0)
        topView.itemStyle = JYSegmentItemStyle(barHeight: 100, textNormalColor: UIColor.black, textNormalFont: UIFont.systemFont(ofSize: 15),textSelectColor: UIColor.magenta,textSelectFont: UIFont.systemFont(ofSize: 22, weight: .semibold), itemWidth: 100, itemSpacing: 10, lineViewHeight: 5, lineViewColor: UIColor.red, lineViewLayer: nil)
        topView.tag = 1000
        topView.segmentDelegate = self
        contentView.pageViewDelegate = self
        self.view.addSubview(topView)
        self.view.addSubview(contentView)
        let vd:[String:UIView] = ["topView":topView,"contentView":contentView]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[topView]|", options: [], metrics: nil, views: vd))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[topView]-10-[contentView]", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: vd))
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
        topView.updateSelectIndex(currentIndex: currentIndex)
    }
    
    func numberOfSegmentView(in segmentView: JYCustomSegmentView) -> Int {
        return datas.count
    }
    func dataSourceOfSegmentView(in segmentView: JYCustomSegmentView) -> [String] {
        return datas
    }
    func didSelectSegmentItem(in segmentView: JYCustomSegmentView, selectIndex: Int) {
        debugPrint(selectIndex)
        contentView.resetScrollerViewContentOffSet(selectIndex: selectIndex)
    }
}
