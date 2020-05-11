//
//  CustomerViewController.swift
//  JYCustomSegmentView
//
//  Created by admin on 2019/8/27.
//  Copyright © 2019 Phz. All rights reserved.
//

import UIKit
/// 数据源
struct dataStruct:JYBaseSegmentProtocol {
    
    var reloadStyle:JYSegmentItemStyle?
    
    var titles: [String]
    
    var childViews: [UIView]?
    
    var childControllers: [UIViewController]?

}

/*
 * 继承于JYBaseSegmentController的示例VC
 */
class CustomerViewController: JYBaseSegmentController {

    private lazy var option : JYSegmentItemStyle = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor(red: 1, green: 0.63, blue: 0.25, alpha: 1).cgColor, UIColor(red: 1, green: 0.52, blue: 0.22, alpha: 1).cgColor]
        layer.locations = [0, 1]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        var option = JYSegmentItemStyle()
        option.lineViewHeight = 5
//        option.itemViewType = .fixedWidthType
        option.anmationViewType = .autoWidthLineType
        option.scrollType = .fixedSpaceType
        option.itemSpacing = 20
        option.lineViewLayer = layer
        option.lineCornerRadius = 1
//        option.barBackGroundColor = UIColor.magenta
//        option.itemBackGroundColor = UIColor.brown
        return option
    }()
    private var arrVC:[UIViewController] = [] {
        willSet {
            self.arrVC.removeAll()
        }
    }
    private var arrView:[UIView] = [] {
        willSet {
            self.arrView.removeAll()
        }
    }
    private var dataArr:[String] = [] {
        didSet {
            for _ in dataArr {
                let v = JYTestView()
                self.arrView.append(v)
                let vc = JYTestVC()
                self.arrVC.append(vc)
            }
            print("self.arrView.count = \(self.arrView.count)")
            print("self.arrVC.count = \(self.arrVC.count)")
//            self.datas?.childControllers = arrVC
            self.datas?.childViews = arrView
            self.datas?.titles = dataArr
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.datas = dataStruct(reloadStyle: option, titles: dataArr, childViews: arrView, childControllers: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.dataArr = ["限速","名义"]
        topView.reloadSegmentDatas()
    }
}

extension CustomerViewController {
    
    override func scrollViewDeceleratingAction(currentIndex: Int) {
        super.scrollViewDeceleratingAction(currentIndex: currentIndex)
    }
    override func didSelectSegmentItem(in segmentView: JYCustomSegmentView, selectIndex: Int) {
        super.didSelectSegmentItem(in: segmentView, selectIndex: selectIndex)
        debugPrint(selectIndex)
    }
    /// 如需动态更新数据源可重写次方法
    override func numberOfSegmentView(in segmentView: JYCustomSegmentView) -> Int {
        return dataArr.count
    }
    override func dataSourceOfSegmentView(in segmentView: JYCustomSegmentView) -> [Any] {
        return dataArr
    }
}
