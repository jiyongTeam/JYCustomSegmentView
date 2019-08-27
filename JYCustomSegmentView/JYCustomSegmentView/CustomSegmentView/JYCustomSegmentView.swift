//
//  JYCustomSegmentView.swift
//  rts
//
//  Created by admin on 2019/8/15.
//  Copyright © 2019 Phz. All rights reserved.
//

import UIKit
/*
 * 自定义segment
 */
open class JYCustomSegmentView: UIScrollView {
    /// 当前选中的index 默认第一个
    open var selectIndex:Int = 0 {
        willSet {
            resetItemSelectStatus(currentIndex: self.selectIndex, selectStatus: false)
        }
        didSet {
            resetAnmationLineViewFrame(currentIndex: self.selectIndex )
            resetItemSelectStatus(currentIndex: self.selectIndex, selectStatus: true )
        }
    }
    /// 事件功能代理
    open weak var segmentDelegate:JYCustomizeSegmentDelegate?
    /// 数据源代理
    open weak var segmentDataSource:JYCustomizeSegmentDataSource? {
        didSet {
            titleArray = self.segmentDataSource?.dataSourceOfSegmentView(in: self)
        }
    }
    open var itemStyle = JYSegmentItemStyle()
    private let contentView = UIView()
    /// 动画view
    private lazy var anmationLineView : UIView = {
        let line = UIView()
        line.backgroundColor = self.itemStyle.lineViewColor
        self.contentView.addSubview(line)
        return line
    }()
    /// 存储item相关属性
    private lazy var itemModelArr:[LineViewSetModel] = []
    /// 存储item
    private lazy var itemSubViews:[UIButton] = []
    private var lastIndexModel:LineViewSetModel?
    private var titleArray:[String]? {
        didSet {
            resetData()
        }
    }

    /// 建议创建静态数据的view使用此初始化方法（如需刷新数据，使用代理设置数据源）
    public convenience init(dataArray:[String]?,option:JYSegmentItemStyle) {
        self.init()
        self.itemStyle = option
        if dataArray != nil {
            titleArray = dataArray
            configerContentView()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setScrollView()
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        debugPrint(self.frame)
        reloadEqualScreenTypeView()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        debugPrint("销毁 --- \(self.classForCoder)")
    }
}

// MARK: - pubilc api
extension JYCustomSegmentView {
    /// 更新当前选中的item
    open func updateSelectIndex(currentIndex:Int) {
        selectIndex = currentIndex
    }
    /// 代理刷新数据
    open func reloadSegmentDatas() {
        titleArray = self.segmentDataSource?.dataSourceOfSegmentView(in: self)
    }
}

// MARK: - 事件处理
extension JYCustomSegmentView {
    /// 根据数据源刷新UI
    private func resetData() {
        guard let dataArray = titleArray,dataArray.isEmpty == false else {
            return
        }
        if dataArray.count == itemSubViews.count {
            for (index,item) in dataArray.enumerated() {
                itemSubViews[index].setTitle(item, for: .normal)
            }
        }else{
            /// 数据源改动，重新布局
            configerContentView()
        }
    }
    /// 点击切换item事件
    @objc private func tapAction(tap:UIButton) {
        let index = tap.tag - 100
        if index != selectIndex {
            selectIndex = index
            self.segmentDelegate?.didSelectSegmentItem(in: self, selectIndex: index)
        }
    }
    /// 设置更新动画线条的位置
    private func resetAnmationLineViewFrame(currentIndex:Int) {
        guard currentIndex < itemModelArr.count else {
            return
        }
        let model = itemModelArr[currentIndex]
        var lineWidth = itemStyle.anmationViewType == .autoWidthLineType ? model.contentWidth : model.itemWidth
        if itemStyle.anmationViewType == .autoWidthLineType , model.contentWidth > model.itemWidth {
            lineWidth = model.itemWidth
        }
        anmationLineView.bounds = CGRect(x: 0, y: 0, width: lineWidth, height: itemStyle.lineViewHeight)
        anmationLineView.center.y = itemStyle.barHeight - itemStyle.lineViewHeight/2
        UIView.animate(withDuration: 0.25) {
            self.anmationLineView.center.x = model.itemCenter.x
        }
        self.itemStyle.lineViewLayer?.frame = anmationLineView.bounds
        scrollerToVisible(currentIndex: currentIndex)
    }
    /// 设置更新scrollView的滑动位置
    private func scrollerToVisible(currentIndex:Int) {
        guard itemStyle.itemViewType != .equalScreenType else {
            return
        }
        guard self.contentSize.width > self.frame.size.width else {
            return
        }
        let model = itemModelArr[currentIndex]
        let s_width = self.frame.size.width
        if itemStyle.scrollType == .centerType {
            if model.itemCenter.x < s_width/2 {
                /// 移到最左边
                self.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }else if model.itemCenter.x > self.contentSize.width - s_width/2 {
                /// 移到最右边
                self.setContentOffset(CGPoint(x: self.contentSize.width - s_width, y: 0), animated: true)
            }else {
                /// 计算偏移距离
                let offSetX = model.itemCenter.x - s_width/2
                self.setContentOffset(CGPoint(x: offSetX , y: 0), animated: true)
            }
        }else{
            let nextIndex = currentIndex + 1
            let lastIndex = currentIndex - 1
            if let lastModel = lastIndexModel ,model.modelIndex < lastModel.modelIndex {
                /// 自右向左点击移动
                guard lastIndex < itemModelArr.count,lastIndex > 0 else {
                    self.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    return
                }
                if itemModelArr[lastIndex].itemCenter.x - contentOffset.x < s_width {
                    let offSet = itemModelArr[lastIndex].itemCenter.x - itemModelArr[currentIndex].itemCenter.x + contentOffset.x
                    if contentOffset.x > 0, offSet > 0 {
                        self.setContentOffset(CGPoint(x: offSet, y: 0), animated: true)
                    }else{
                        self.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    }
                }else{
                    debugPrint("自右向左 --- 在屏幕内不移动")
                }
            }else if let lastModel = lastIndexModel ,model.modelIndex > lastModel.modelIndex {
                /// 自左向右点击移动
                guard nextIndex < itemModelArr.count else {
                    /// 移动到最右边
                    let offSet = contentSize.width - s_width
                    self.setContentOffset(CGPoint(x: offSet, y: 0), animated: true)
                    return
                }
                if itemModelArr[nextIndex].itemCenter.x - contentOffset.x - s_width > 0 {
                    if nextIndex < itemModelArr.count ,contentSize.width - s_width - contentOffset.x > model.itemWidth {
                        let offSet = itemModelArr[nextIndex].itemCenter.x - itemModelArr[currentIndex].itemCenter.x + contentOffset.x
                        self.setContentOffset(CGPoint(x: offSet, y: 0), animated: true)
                    }else{
                        /// 移动到最右边
                        let offSet = contentSize.width - s_width
                        self.setContentOffset(CGPoint(x: offSet, y: 0), animated: true)
                    }
                }else{
                    debugPrint("自左向右点击---屏幕内不移动")
                }
            }else {
                debugPrint("点击的是当前选中的item，不移动")
        }
        self.lastIndexModel = model
        }
    }
    /// 更新选择项的选中状态
    private func resetItemSelectStatus(currentIndex:Int,selectStatus:Bool) {
        debugPrint(currentIndex)
        guard currentIndex < itemSubViews.count else {
            return
        }
        let item = itemSubViews[currentIndex]
        item.isSelected = selectStatus
        item.titleLabel?.font = selectStatus == true ? itemStyle.textSelectFont : itemStyle.textNormalFont
    }
}

// MARK: - UI布局
extension JYCustomSegmentView {
    /// 设置ScrollView相关属性
    private func setScrollView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.bounces = false
        self.addSubview(contentView)
    }
    /// 刷新等屏布局样式UI
    private func reloadEqualScreenTypeView() {
        guard itemStyle.itemViewType == .equalScreenType,let arr = titleArray, arr.isEmpty == false else {
            return
        }
        if arr.count == itemSubViews.count {
            contentView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: itemStyle.barHeight)
            for i in 0...itemSubViews.count - 1 {
                let btn = itemSubViews[i]
                let model = itemModelArr[i]
                model.itemWidth = self.frame.width/CGFloat(arr.count)
                btn.frame = CGRect(x: model.itemWidth * CGFloat(i), y: 0, width: model.itemWidth, height: itemStyle.barHeight - itemStyle.lineViewHeight)
                model.itemCenter = btn.center
                model.modelIndex = i
            }
            /// 设置动画线条的初始位置
            resetAnmationLineViewFrame(currentIndex: self.selectIndex)
        }
    }
    /// 布局contentView
    private func configerContentView() {
        contentView.backgroundColor = itemStyle.barBackGroundColor
        contentView.subviews.forEach({$0.removeFromSuperview()
        })
        if let itemCount = titleArray?.count {
            configerContentViewUI(dataCount: itemCount)
        }
        /// 设置动画线条的初始位置
        resetAnmationLineViewFrame(currentIndex: self.selectIndex)
        if let caLayer = self.itemStyle.lineViewLayer {
            anmationLineView.layer.insertSublayer(caLayer, at: 0)
        }
        if let radius = self.itemStyle.lineCornerRadius {
            anmationLineView.layer.cornerRadius = radius
            anmationLineView.layer.masksToBounds = true
        }
    }
    /// 布局items
    private func configerContentViewUI(dataCount:Int) {
        guard let dataArr = titleArray,dataArr.isEmpty == false else {
            return
        }
        let space = itemStyle.itemSpacing
        let s_width = self.frame.size.width
        for i in 0...(dataCount - 1) {
            let btn = UIButton(type: .custom)
            btn.backgroundColor = itemStyle.itemBackGroundColor
            btn.setTitle(dataArr[i], for: .normal)
            btn.setTitleColor(itemStyle.textNormalColor, for: .normal)
            btn.setTitleColor(itemStyle.textSelectColor, for: .selected)
            if selectIndex == i {
                btn.titleLabel?.font = itemStyle.textSelectFont
                btn.isSelected = true
            }else{
                btn.titleLabel?.font = itemStyle.textNormalFont
                btn.isSelected = false
            }
            btn.tag = i + 100
            btn.addTarget(self, action: #selector(self.tapAction(tap:)), for: .touchUpInside)
            contentView.addSubview(btn)
            itemSubViews.append(btn)
            let model = LineViewSetModel()
            let itemRect:CGRect = self.getTextRectSize(text: dataArr[i], font: itemStyle.textSelectFont, size: CGSize(width: 1000, height: 1000))
            debugPrint(itemRect)
            model.contentWidth = itemRect.size.width
            switch itemStyle.itemViewType {
            case .defaultType:
                model.itemWidth = itemRect.size.width
                if i == 0 {
                    btn.frame = CGRect(x: 0, y: 0, width: itemRect.size.width, height: itemStyle.barHeight - itemStyle.lineViewHeight)
                }else {
                    let btn_x = itemSubViews[i-1].frame.origin.x + itemModelArr[i-1].itemWidth + itemStyle.itemSpacing
                    btn.frame = CGRect(x: btn_x, y: 0, width: itemRect.size.width, height: itemStyle.barHeight - itemStyle.lineViewHeight)
                }
            case .equalScreenType:
                model.itemWidth = s_width/CGFloat(dataCount)
                btn.frame = CGRect(x: model.itemWidth * CGFloat(i), y: 0, width: model.itemWidth, height: itemStyle.barHeight - itemStyle.lineViewHeight)
            case .fixedWidthType:
                model.itemWidth = itemStyle.itemWidth
                btn.frame = CGRect(x: (model.itemWidth + space) * CGFloat(i), y: 0, width: model.itemWidth, height: itemStyle.barHeight - itemStyle.lineViewHeight)
            }
            model.itemCenter = btn.center
            model.modelIndex = i
            itemModelArr.append(model)
        }
        /// 设置scrollView的ContentSize
        if itemStyle.itemViewType == .defaultType {
            self.contentSize = CGSize(width: self.getArraySum() + (space * CGFloat(dataCount - 1)), height: itemStyle.barHeight)
            contentView.frame = CGRect(x: 0, y: 0, width: self.contentSize.width, height: itemStyle.barHeight)
        }else if itemStyle.itemViewType == .fixedWidthType {
            self.contentSize = CGSize(width: itemStyle.itemWidth * CGFloat(dataCount) + (space * CGFloat(dataCount - 1)), height: itemStyle.barHeight)
            contentView.frame = CGRect(x: 0, y: 0, width: self.contentSize.width, height: itemStyle.barHeight)
        }else {
            contentView.frame = CGRect(x: 0, y: 0, width: s_width, height: itemStyle.barHeight)
        }
    }
    /// 计算数字数组的和
    private func getArraySum() -> CGFloat {
        var result:CGFloat = 0
        for item in itemModelArr {
            result = result + item.itemWidth
        }
        return result
    }
    /// 计算文字大小
    private func getTextRectSize(text: String,font: UIFont,size: CGSize) -> CGRect {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = (text as NSString).boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect;
    }
}


