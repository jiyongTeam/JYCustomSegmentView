//
//  JYCustomSegmentView.swift
//  rts
//
//  Created by admin on 2019/8/15.
//  Copyright © 2019 张冬. All rights reserved.
//

import UIKit

class JYCustomSegmentView: UIScrollView {
    /// 当前选中的index 默认第一个
    var selectIndex:Int = 0 {
        willSet {
            resetItemSelectStatus(currentIndex: self.selectIndex, selectStatus: false)
        }
        didSet {
            resetAnmationLineViewFrame(currentIndex: self.selectIndex )
            resetItemSelectStatus(currentIndex: self.selectIndex, selectStatus: true )
        }
    }
    /// 代理
    weak var segmentDelegate:JYCustomizeSegmentDelegate?
    var itemStyle = JYSegmentItemStyle(barHeight: 50, textNormalColor: UIColor.red, textNormalFont: UIFont.systemFont(ofSize: 15),textSelectColor: UIColor.blue,textSelectFont: UIFont.systemFont(ofSize: 22, weight: .semibold), itemWidth: 100, itemSpacing: 20, lineViewHeight: 2, lineViewColor: nil, lineViewLayer: nil)
    /// item布局样式
    private var itemViewType:JYSegmentViewType = .defaultType
    /// 选中线条样式
    private var anmationViewType:JYSegmentLineViewType = .defaultLineType
    /// scrollview移动样式
    private var scrollType:JYScrollAnmationType = .fixedSpaceType
    private let contentView = UIView()
    /// 动画view
    private lazy var anmationLineView : UIView = {
        let line = UIView()
        line.backgroundColor = self.itemStyle.lineViewColor
//        line.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(line)
        return line
    }()
    /// 存储item相关属性
    private lazy var itemModelArr:[LineViewSetModel] = []
    /// 存储item
    private lazy var itemSubViews:[UIButton] = []
    private var lastIndexModel:LineViewSetModel?



    
    convenience init(itemType:JYSegmentViewType,lineViewType:JYSegmentLineViewType = .defaultLineType,scrollType:JYScrollAnmationType = .fixedSpaceType) {
        self.init()
        self.itemViewType = itemType
        self.anmationViewType = lineViewType
        self.scrollType = scrollType
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setScrollView()
        self.addSubview(contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - pubilc api
extension JYCustomSegmentView {
    /// 更新当前选中的item
    func updateSelectIndex(currentIndex:Int) {
        selectIndex = currentIndex
    }
    /// 刷新数据
    func reloadSegmentDatas() {
        resetData()
    }
}

// MARK: - 事件处理
extension JYCustomSegmentView {
    
    private func resetData() {
        guard let dataArray = self.segmentDelegate?.dataSourceOfSegmentView(in: self),dataArray.isEmpty == false else {
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
        }
        self.segmentDelegate?.didSelectSegmentItem(in: self, selectIndex: index)
    }
    /// 设置更新动画线条的位置
    private func resetAnmationLineViewFrame(currentIndex:Int) {
        guard currentIndex < itemModelArr.count else {
            return
        }
        let model = itemModelArr[currentIndex]
        var lineWidth = self.anmationViewType == .autoWidthLineType ? model.contentWidth : model.itemWidth
        if self.anmationViewType == .autoWidthLineType , model.contentWidth > model.itemWidth {
            lineWidth = model.itemWidth
        }
        anmationLineView.bounds = CGRect(x: 0, y: 0, width: lineWidth, height: itemStyle.lineViewHeight)
        anmationLineView.center.y = itemStyle.barHeight - itemStyle.lineViewHeight
        UIView.animate(withDuration: 0.25) {
            self.anmationLineView.center.x = model.itemCenter.x
        }
        scrollerToVisible(currentIndex: currentIndex)
    }
    /// 设置更新scrollView的滑动位置
    private func scrollerToVisible(currentIndex:Int) {
        guard itemViewType != .equalScreenType else {
            return
        }
        let model = itemModelArr[currentIndex]
        let s_width = self.frame.size.width
        if scrollType == .centerType {
            if model.itemCenter.x < s_width/2 {
                // 移到最左边
                self.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }else if model.itemCenter.x > self.contentSize.width - s_width/2 {
                // 移到最右边
                self.setContentOffset(CGPoint(x: self.contentSize.width - s_width, y: 0), animated: true)
            }else {
                // 计算偏移距离
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
                    if contentOffset.x > 0 {
                        let offSet = itemModelArr[lastIndex].itemCenter.x - itemModelArr[currentIndex].itemCenter.x + contentOffset.x
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
    }
    /// 布局contentView
    private func configerContentView() {
        
        contentView.subviews.forEach({$0.removeFromSuperview()
        })
        if let itemCount = self.segmentDelegate?.numberOfSegmentView(in: self) {
            configerContentViewUI(dataCount: itemCount)
        }
        /// 设置动画线条的初始位置
        resetAnmationLineViewFrame(currentIndex: 0)
    }
    /// 布局items
    private func configerContentViewUI(dataCount:Int) {
        guard let dataArr = self.segmentDelegate?.dataSourceOfSegmentView(in: self),dataArr.isEmpty == false else {
            return
        }
        let space = itemStyle.itemSpacing
        let s_width = self.frame.size.width
        for i in 0...(dataCount - 1) {
            let btn = UIButton(type: .custom)
            btn.backgroundColor = UIColor.yellow
            btn.setTitle(dataArr[i], for: .normal)
            btn.setTitleColor(itemStyle.textNormalColor, for: .normal)
            btn.setTitleColor(itemStyle.textSelectColor, for: .selected)
            if selectIndex == i {
                btn.titleLabel?.font = itemStyle.textSelectFont
                btn.isSelected = true
            }else{
                btn.titleLabel?.font = itemStyle.textNormalFont
            }
            btn.tag = i + 100
            btn.addTarget(self, action: #selector(self.tapAction(tap:)), for: .touchUpInside)
            contentView.addSubview(btn)
            itemSubViews.append(btn)
            let model = LineViewSetModel()
            let itemRect:CGRect = self.getTextRectSize(text: dataArr[i], font: itemStyle.textSelectFont, size: CGSize(width: 1000, height: 1000))
            debugPrint(itemRect)
            model.contentWidth = itemRect.size.width
            switch itemViewType {
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
        if itemViewType == .defaultType {
            self.contentSize = CGSize(width: self.getArraySum() + (space * CGFloat(dataCount - 1)), height: itemStyle.barHeight)
            contentView.frame = CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)
        }else if itemViewType == .fixedWidthType {
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


