//
//  StaicDataSourceController.swift
//  JYCustomSegmentView
//
//  Created by admin on 2019/8/27.
//  Copyright © 2019 Phz. All rights reserved.
//

import UIKit
/**
 * 静态数据源示例VC
 */
class StaicDataSourceController: UIViewController {

    private lazy var style:JYSegmentItemStyle =  {
        var s = JYSegmentItemStyle()
        s.itemViewType = .defaultType
        s.itemSpacing = 10
//        s.itemStyleOption.isShowSelectStaus = false
        s.itemStyleOption.textNormalFont = UIFont.systemFont(ofSize: 12)
//        s.barBackGroundColor = UIColor.magenta
//        s.itemStyleOption.itemBackGroundColor = UIColor.yellow
        s.itemStyleOption.bottom = 10
        return s
    }()
    private lazy var headerView = JYCustomSegmentView(dataArray: ["水调歌头","明月几时有","把酒问青天","不知天上宫阙","今夕是何年","但愿人长久","千里共婵娟"], option: self.style)
    private lazy var contentView = JYSegmentContentView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configerUI()
        headerView.segmentDelegate = self
        contentView.pageViewDelegate = self
    }
}

extension StaicDataSourceController : JYSegmentContentViewDelegate,JYCustomizeSegmentDelegate {
    func scrollViewDeceleratingAction(currentIndex: Int) {
        self.headerView.updateSelectIndex(currentIndex: currentIndex)
    }
    
    func didSelectSegmentItem(in segmentView: JYCustomSegmentView, selectIndex: Int) {
        self.contentView.resetScrollerViewContentOffSet(selectIndex: selectIndex)
    }
}

extension StaicDataSourceController {
    
    private func configerUI() {
        contentView.addViewsToContentView(subViews: [JYTestView(),JYTestView(),JYTestView(),JYTestView(),JYTestView(),JYTestView(),JYTestView()])
        self.view.addSubview(headerView)
        self.view.addSubview(contentView)
        let vd:[String:UIView] = ["headerView":headerView,"contentView":contentView]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[headerView]|", options: [], metrics: nil, views: vd))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[headerView][contentView]", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: vd))
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

