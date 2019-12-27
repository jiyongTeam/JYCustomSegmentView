//
//  DynamicDataSourceController.swift
//  JYCustomSegmentView
//
//  Created by admin on 2019/8/27.
//  Copyright © 2019 Phz. All rights reserved.
//

import UIKit
/*
 * 动态数据源示例VC
 */
class DynamicDataSourceController: UIViewController {

    private lazy var style:JYSegmentItemStyle =  {
        var s = JYSegmentItemStyle()
        s.itemViewType = .defaultType
        s.itemSpacing = 10
        return s
    }()
    private lazy var headerView = JYCustomSegmentView()
    private lazy var contentView = JYSegmentContentView()
    private var dataArray:[NSAttributedString] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configerUI()
        headerView.segmentDelegate = self
        headerView.segmentDataSource = self
        contentView.pageViewDelegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        dataArray = ["舒适","策士","基本数据","基本类型","测试","策士","测试卡","测"]
        let att = NSAttributedString(attributedString: NSAttributedString(string: "9999", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12),NSAttributedString.Key.foregroundColor:UIColor.red]))
        let att1 = NSMutableAttributedString(string: "全部 ", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.black])
        att1.append(att)
        let att2 = NSMutableAttributedString(string: "好评 ", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.black])
        att2.append(att)
        let att3 = NSMutableAttributedString(string: "中评 ", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.black])
        att3.append(att)
        let att4 = NSMutableAttributedString(string: "差评 ", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.black])
        att4.append(att)
        dataArray = [att1,att2,att3,att4]
        headerView.reloadSegmentDatas()
    }
}

extension DynamicDataSourceController : JYSegmentContentViewDelegate,JYCustomizeSegmentDelegate,JYCustomizeSegmentDataSource {
    
    func numberOfSegmentView(in segmentView: JYCustomSegmentView) -> Int {
        return dataArray.count
    }
    
    func dataSourceOfSegmentView(in segmentView: JYCustomSegmentView) -> [Any] {
        return dataArray
    }
    
    func scrollViewDeceleratingAction(currentIndex: Int) {
        self.headerView.updateSelectIndex(currentIndex: currentIndex)
    }
    
    func didSelectSegmentItem(in segmentView: JYCustomSegmentView, selectIndex: Int) {
        self.contentView.resetScrollerViewContentOffSet(selectIndex: selectIndex)
    }
}

extension DynamicDataSourceController {
    
    private func setHeaderViewOptions() {
        let layer = CAGradientLayer()
        layer.colors = [UIColor(red: 1, green: 0.63, blue: 0.25, alpha: 1).cgColor, UIColor(red: 1, green: 0.52, blue: 0.22, alpha: 1).cgColor]
        layer.locations = [0, 1]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        var option = JYSegmentItemStyle()
        option.lineViewHeight = 5
        option.itemWidth = 80
//        option.itemBackGroundColor = UIColor.yellow
        option.itemViewType = .equalScreenType
        option.anmationViewType = .autoWidthLineType
        option.scrollType = .centerType
        option.itemSpacing = 20
        option.lineViewLayer = layer
        option.lineCornerRadius = 1
        option.itemStyleOption.isShowSelectStaus = false
        option.itemStyleOption.textSelectFont = option.itemStyleOption.textNormalFont
        option.itemStyleOption.textSelectColor = option.itemStyleOption.textNormalColor
        headerView.itemStyle = option
    }
    
    private func configerUI() {
        self.setHeaderViewOptions()
        contentView.addViewsToContentView(subViews: [JYTestView(),JYTestView(),JYTestView(),JYTestView(),JYTestView(),JYTestView(),JYTestView(),JYTestView()])
        self.view.addSubview(headerView)
        self.view.addSubview(contentView)
        let vd:[String:UIView] = ["headerView":headerView,"contentView":contentView]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[headerView]|", options: [], metrics: nil, views: vd))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[headerView(\(style.barHeight))][contentView]", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: vd))
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
