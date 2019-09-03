
//
//  JYSegmentContentView.swift
//  rts
//
//  Created by admin on 2019/8/15.
//  Copyright © 2019 Phz. All rights reserved.
//

import UIKit
/**
 *  segment pageView
 **/
open class JYSegmentContentView: UIScrollView {
    
    open weak var pageViewDelegate:JYSegmentContentViewDelegate?
    private var lastIndex:Int?
    private var currentIndex:Int?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isPagingEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
        self.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        debugPrint("销毁 --- \(self.classForCoder)")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if self.subviews.isEmpty == false {
            let s_width = self.frame.size.width
            let s_height = self.frame.size.height
            for i in 0...self.subviews.count-1 {
                let v = self.subviews[i]
                v.frame = CGRect(x: s_width * CGFloat(i), y: 0, width: s_width, height: s_height)
            }
            self.contentSize = CGSize(width: s_width * CGFloat(self.subviews.count), height: s_height)
        }
    }
}

extension JYSegmentContentView {
    
    /// 添加controller
    open func addControllersToContentView(superController:UIViewController,controllers:[UIViewController]) {
        guard controllers.isEmpty == false,self.subviews.count != controllers.count else {
            return
        }
        let s_width = self.frame.size.width
        let s_height = self.frame.size.height
        for i in 0...controllers.count-1 {
            let vc = controllers[i]
            vc.didMove(toParent: superController)
            superController.addChild(vc)
            vc.view.frame = CGRect(x: s_width * CGFloat(i), y: 0, width: s_width, height: s_height)
            self.addSubview(vc.view)
        }
    }
    /// 添加view
    open func addViewsToContentView(subViews:[UIView]) {
        guard subViews.isEmpty == false,self.subviews.count != subViews.count else {
            return
        }
        let s_width = self.frame.size.width
        let s_height = self.frame.size.height
        for i in 0...subViews.count-1 {
            let v = subViews[i]
            v.translatesAutoresizingMaskIntoConstraints = true
            v.frame = CGRect(x: s_width * CGFloat(i), y: 0, width: s_width, height: s_height)
            self.addSubview(v)
        }
    }
    /// 重新设置contentOffSet
    open func resetScrollerViewContentOffSet(selectIndex:Int) {
        let s_width = self.frame.size.width
        self.setContentOffset(CGPoint(x: s_width * CGFloat(selectIndex), y: 0), animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension JYSegmentContentView : UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(self.contentOffset.x/self.frame.size.width)
        self.currentIndex = index
        if lastIndex != currentIndex {
            self.pageViewDelegate?.scrollViewDeceleratingAction(currentIndex: index)
        }
        self.lastIndex = index
    }
    /// 解决手势返回与滑动手势冲突问题
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.panBack(gestureRecognizer: gestureRecognizer)
    }
    private func panBack(gestureRecognizer:UIGestureRecognizer) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let point = panGesture.translation(in: self)
            if  UIGestureRecognizer.State.began == panGesture.state || UIGestureRecognizer.State.possible == panGesture.state {
                let loctaion = panGesture.location(in: self)
                if point.x > 0 && loctaion.x < 90 && self.contentOffset.x <= 0 {
                    return false
                }
            }
        }
        return true
    }
}
