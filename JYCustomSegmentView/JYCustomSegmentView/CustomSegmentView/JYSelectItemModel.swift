//
//  JYSelectItemModel.swift
//  rts
//
//  Created by admin on 2019/8/15.
//  Copyright © 2019 Phz. All rights reserved.
//

import UIKit
/// 自定义SegmentView的事件功能代理
public protocol JYCustomizeSegmentDelegate : class {
    /// item点击事件
    func didSelectSegmentItem(in segmentView:JYCustomSegmentView,selectIndex:Int)
}
/// 自定义SegmentView的数据源代理
public protocol JYCustomizeSegmentDataSource : class {
    /// 设置共有多少个item
    func numberOfSegmentView(in segmentView:JYCustomSegmentView) -> Int
    /// 设置数据源
    func dataSourceOfSegmentView(in segmentView:JYCustomSegmentView) -> [Any]
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
/// - fixedWidthLineType: lineView的固定宽度
public enum JYSegmentLineViewType {
    case defaultLineType
    case autoWidthLineType
    case fixedWidthLineType(width:CGFloat)
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
    public var itemViewType:JYSegmentViewType = .equalScreenType
    /// 选中线条样式
    public var anmationViewType:JYSegmentLineViewType = .autoWidthLineType
    /// scrollview移动样式
    public var scrollType:JYScrollAnmationType = .fixedSpaceType
    /// 整个控件的高度
    public var barHeight:CGFloat = 60
    /// 整个控件左边距
    public var barLeading:CGFloat = 0
    /// 整个控件右边距
    public var barTring:CGFloat = 0
    /// 整个控件的背景色
    public var barBackGroundColor: UIColor = UIColor.clear
    /// 按钮宽度
    public var itemWidth:CGFloat = 100
    /// 按钮左右间隔宽度
    public var itemSpacing:CGFloat = 0
    /// 横线高度
    public var lineViewHeight:CGFloat = 6
    /// 横线颜色
    public var lineViewColor:UIColor =  UIColor(red: 1, green: 0.52, blue: 0.22, alpha: 1)
    /// 横线圆角
    public var lineCornerRadius: CGFloat?
    /// 横线渐变色layer
    public var lineViewLayer:CAGradientLayer?
    /// 选项卡设置模型
    public var itemStyleOption : JYItemSetStruct = JYItemSetStruct()
    
    public init() {}
}
/// item相关设置
public struct JYItemSetStruct {
    /// 是否显示选中状态
    public var isShowSelectStaus = true
    /// 文本底部间距
    public var bottom:CGFloat = 0
    /// 文本默认颜色
    public var textNormalColor: UIColor = UIColor(red: 0.26, green: 0.26, blue: 0.26, alpha: 1)
    /// 文本默认字体
    public var textNormalFont: UIFont = UIFont.systemFont(ofSize: 16)
    /// 文本选中颜色
    public var textSelectColor:UIColor = UIColor(red: 0.01, green: 0.01, blue: 0.01, alpha: 1)
    /// 文本选中字体
    public var textSelectFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    /// 默认按钮背景色
    public var itemBackGroundColor: UIColor = UIColor.clear
    /// 选中按钮背景色
    public var itemSelectBackGroundColor: UIColor?
    
    public init() {}
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
