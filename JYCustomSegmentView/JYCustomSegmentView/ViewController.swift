//
//  ViewController.swift
//  JYCustomSegmentView
//
//  Created by admin on 2019/8/20.
//  Copyright © 2019 Phz. All rights reserved.
//

import UIKit

struct data:JYBaseSegmentProtocol {
    var titles: [String]
    
    var childViews: [UIView]?
    
    var childControllers: [UIViewController]?
}

final class ViewController: JYBaseSegmentController {
    
    let arrVC:[UIViewController] = [JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC()]
    let arrView:[UIView] = [JYTestView(),JYTestView(),JYTestView(),JYTestView(),JYTestView(),JYTestView(),JYTestView(),JYTestView(),JYTestView(),JYTestView(),JYTestView(),JYTestView()]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datas = data(titles: ["测试1","测试2","测试3","测试4","测试5","测试6","明天天气很晴朗","限速","名义","天气","下雨","晴天霹雳"], childViews: arrView, childControllers: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var option = JYSegmentItemStyle()
        option.lineViewHeight = 5
        option.textSelectColor = UIColor.cyan
        topView.itemStyle.itemViewType = .defaultType
        topView.itemStyle.anmationViewType = .autoWidthLineType
        topView.itemStyle.scrollType = .centerType
        topView.itemStyle = option
        topView.reloadSegmentDatas()
        self.configerChildViews()
    }
}

extension ViewController {
    
    override func scrollViewDeceleratingAction(currentIndex: Int) {
        super.scrollViewDeceleratingAction(currentIndex: currentIndex)
        debugPrint(currentIndex)
    }
    override func didSelectSegmentItem(in segmentView: JYCustomSegmentView, selectIndex: Int) {
        super.didSelectSegmentItem(in: segmentView, selectIndex: selectIndex)
        debugPrint(selectIndex)
    }
}
