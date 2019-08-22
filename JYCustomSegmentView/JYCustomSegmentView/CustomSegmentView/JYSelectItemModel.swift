//
//  JYSelectItemModel.swift
//  rts
//
//  Created by admin on 2019/8/15.
//  Copyright © 2019 张冬. All rights reserved.
//

import UIKit
/// 自定义SegmentView的选中事件代理
public protocol JYCustomizeSegmentDelegate : class {
    /// 设置共有多少个item
    func numberOfSegmentView(in segmentView:JYCustomSegmentView) -> Int
    /// 设置数据源
    func dataSourceOfSegmentView(in segmentView:JYCustomSegmentView) -> [String]
    /// item点击事件
    func didSelectSegmentItem(in segmentView:JYCustomSegmentView,selectIndex:Int)
}

/// SegmentContentView可滑动事件
public protocol JYSegmentContentViewDelegate : class {
    func scrollViewDeceleratingAction(currentIndex:Int)
}
/// 选项卡类型
///
/// - defaultType: 默认类型：控件宽度随文字宽度变化，控件间距相等
/// - equalScreenType: 均分屏幕宽度：不可滑动，控件均分屏幕宽度
/// - fixedWiethType: 固定宽度：控件宽度外部确定
public enum JYSegmentViewType {
    case defaultType
    case equalScreenType
    case fixedWidthType
}

/// 动画view的类型
///
/// - defaultLineType: 默认类型：宽度与控件宽度一致
/// - autoWidthLineType: 宽度与控件文字宽度保持一致
public enum JYSegmentLineViewType {
    case defaultLineType
    case autoWidthLineType
}

/// 超出屏幕移动显示类型
///
/// - centerType: 控件移动到屏幕中心
/// - fixedSpaceType: 下一个控件的中心靠右边距
public enum JYScrollAnmationType {
    case centerType
    case fixedSpaceType
}
/// 选项卡样式协议
public struct JYSegmentItemStyle {
    /// item布局样式
    var itemViewType:JYSegmentViewType = .defaultType
    /// 选中线条样式
    var anmationViewType:JYSegmentLineViewType = .defaultLineType
    /// scrollview移动样式
    var scrollType:JYScrollAnmationType = .fixedSpaceType
    /// 整个控件的高度
    var barHeight:CGFloat = 60
    /// 文本默认颜色
    var textNormalColor: UIColor = UIColor.red
    /// 文本默认字体
    var textNormalFont: UIFont = UIFont.systemFont(ofSize: 15)
    /// 文本选中颜色
    var textSelectColor:UIColor = UIColor.blue
    /// 文本选中字体
    var textSelectFont: UIFont = UIFont.systemFont(ofSize: 22, weight: .semibold)
    /// 控件宽度
    var itemWidth:CGFloat = 0
    /// 控件左右间隔宽度
    var itemSpacing:CGFloat = 0
    /// 横线高度
    var lineViewHeight:CGFloat = 0
    /// 横线颜色
    var lineViewColor:UIColor = UIColor.orange
    /// 横线渐变色layer
    var lineViewLayer:CAGradientLayer?
}

///
class LineViewSetModel: NSObject {
    /// 文字内容宽度
    var contentWidth:CGFloat = 0
    /// 控件宽度
    var itemWidth:CGFloat = 0
    /// 控件center
    var itemCenter : CGPoint = CGPoint(x: 0, y: 0)
    /// mode的index
    var modelIndex:Int = 0
}
