//
//  JYBaseSegmentController.swift
//  JYCustomSegmentView
//
//  Created by admin on 2019/8/22.
//  Copyright © 2019 Phz. All rights reserved.
//

import UIKit

/// 数据协议
public protocol JYBaseSegmentProtocol {
    /// 显示样式刷新
    var reloadStyle:JYSegmentItemStyle? {set get}
    /// 标题
    var titles:[String] {set get}
    /// 添加subViews
    var childViews:[UIView]? {set get}
    /// 添加subControllers
    var childControllers:[UIViewController]? {set get}
}
/**
 * segment选择控件baseViewController
 */
open class JYBaseSegmentController: UIViewController {
    
    private var option = JYSegmentItemStyle()
    open lazy var topView = JYCustomSegmentView(dataArray: ["测试1","测试2","测试3","测4","测试5","测试6","测试7"], option: option )
//    open lazy var topView = JYCustomSegmentView()
    open var datas:JYBaseSegmentProtocol? {
        didSet {
            if let style = self.datas?.reloadStyle {
                topView.itemStyle = style
            }
        }
    }
    private var contentView = JYSegmentContentView()

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentViewUI()
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        topView.reloadSegmentDatas()
    }
}

// MARK: pubilc API 
extension JYBaseSegmentController:JYSegmentContentViewDelegate,JYCustomizeSegmentDelegate,JYCustomizeSegmentDataSource {
    
    open func configerChildViews() {
        if let childControllers = self.datas?.childControllers {
            contentView.addControllersToContentView(superController: self, controllers: childControllers)
        }else if let childViews = self.datas?.childViews {
            contentView.addViewsToContentView(subViews: childViews)
        }else{
            debugPrint("没有设置contentView")
        }
    }
    
    @objc open func scrollViewDeceleratingAction(currentIndex: Int) {
        debugPrint(currentIndex)
        topView.updateSelectIndex(currentIndex: currentIndex)
    }
    
    @objc open func numberOfSegmentView(in segmentView: JYCustomSegmentView) -> Int {
        debugPrint(self.datas)
        if let arr = datas?.titles {
            return arr.count
        }
        return 0
    }
    @objc open func dataSourceOfSegmentView(in segmentView: JYCustomSegmentView) -> [String] {
        if let arr = datas?.titles {
            return arr
        }
        return []
    }
    @objc open func didSelectSegmentItem(in segmentView: JYCustomSegmentView, selectIndex: Int) {
        debugPrint(selectIndex)
        contentView.resetScrollerViewContentOffSet(selectIndex: selectIndex)
    }
}

extension JYBaseSegmentController {
    
    private func setupSegmentViewUI() {
        topView.segmentDelegate = self
//        topView.segmentDataSource = self
        contentView.pageViewDelegate = self
        self.view.addSubview(topView)
        self.view.addSubview(contentView)
        let vd:[String:UIView] = ["topView":topView,"contentView":contentView]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[topView]|", options: [], metrics: nil, views: vd))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[topView(\(topView.itemStyle.barHeight))][contentView]", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: vd))
        if #available(iOS 11.0, *) {
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        } else {
            topView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        }
    }
}
