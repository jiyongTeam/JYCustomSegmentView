//
//  ViewController.swift
//  JYCustomSegmentView
//
//  Created by admin on 2019/8/20.
//  Copyright © 2019 Phz. All rights reserved.
//

import UIKit

struct data:JYBaseSegmentProtocol {
    
    var reloadStyle:JYSegmentItemStyle?
    
    var titles: [String]
    
    var childViews: [UIView]?
    
    var childControllers: [UIViewController]?
}

final class ViewController: JYBaseSegmentController {
    
    let arrVC:[UIViewController] = [JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC(),JYTestVC()]
    let arrView:[UIView] = [JYTestView(),JYTestView(),JYTestView(),JYTestView(),JYTestView(),JYTestView(),JYTestView(),JYTestView()]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTopViewOptions()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configerChildViews()
    }
    
    private func setTopViewOptions() {
        let layer = CAGradientLayer()
        layer.colors = [UIColor(red: 1, green: 0.63, blue: 0.25, alpha: 1).cgColor, UIColor(red: 1, green: 0.52, blue: 0.22, alpha: 1).cgColor]
        layer.locations = [0, 1]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        var option = JYSegmentItemStyle()
        option.lineViewHeight = 5
        option.itemViewType = .fixedWidthType
        option.anmationViewType = .autoWidthLineType
        option.scrollType = .fixedSpaceType
        option.itemSpacing = 20
        option.lineViewLayer = layer
        option.lineCornerRadius = 1
//        option.barBackGroundColor = UIColor.magenta
//        option.itemBackGroundColor = UIColor.brown
        self.datas = data(reloadStyle: option, titles: ["测试1","测试2","明天天气很晴朗","限速","名义","天气","下雨","晴天霹雳"], childViews: arrView, childControllers: nil)
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
