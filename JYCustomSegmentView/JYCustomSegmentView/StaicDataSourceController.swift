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
        s.itemViewType = .equalScreenType
        s.anmationViewType = .fixedWidthLineType(width: 30)
        s.scrollType = .fixedSpaceType
        s.itemSpacing = 10
//        s.itemStyleOption.isShowSelectStaus = false
        s.itemStyleOption.textNormalFont = UIFont.systemFont(ofSize: 12)
//        s.barBackGroundColor = UIColor.magenta
        s.itemStyleOption.itemBackGroundColor = UIColor.yellow
        s.barLeading = 20
        s.barTring = 20
        s.itemStyleOption.bottom = 10
        return s
    }()
    private var testView1:JYTestView = JYTestView() //,"宫阙今夕是何年","我","悦城等","鬼区","又恐琼楼预约","高出","不胜寒","起舞弄轻盈","喝死","在人间"
    private lazy var headerView = JYCustomSegmentView(dataArray: ["水调歌头","明月几时有","把酒"], option: self.style)
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
        contentView.addViewsToContentView(subViews: [testView1,JYTestView(),JYTestView()])
        self.view.addSubview(headerView)
        self.view.addSubview(contentView)
        let vd:[String:UIView] = ["headerView":headerView,"contentView":contentView]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[headerView]|", options: [], metrics: nil, views: vd))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[headerView][contentView]", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: vd))
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

