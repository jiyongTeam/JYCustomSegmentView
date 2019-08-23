
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isPagingEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JYSegmentContentView {
    
    /// 添加controller
    open func addControllersToContentView(superController:UIViewController,controllers:[UIViewController]) {
        guard controllers.isEmpty == false else {
            return
        }
        let s_width = self.frame.size.width
        let s_height = self.frame.size.height
        debugPrint("content --- \(self.frame)")
        for i in 0...controllers.count-1 {
            let vc = controllers[i]
            superController.addChild(vc)
            vc.view.frame = CGRect(x: s_width * CGFloat(i), y: 0, width: s_width, height: s_height)
            self.addSubview(vc.view)
        }
        self.contentSize = CGSize(width: s_width * CGFloat(controllers.count), height: s_height)
    }
    /// 添加view
    open func addViewsToContentView(subViews:[UIView]) {
        guard subViews.isEmpty == false else {
            return
        }
        let s_width = self.frame.size.width
        let s_height = self.frame.size.height
        debugPrint("content --- \(self.frame)")
        for i in 0...subViews.count-1 {
            let v = subViews[i]
            v.frame = CGRect(x: s_width * CGFloat(i), y: 0, width: s_width, height: s_height)
            self.addSubview(v)
        }
        self.contentSize = CGSize(width: s_width * CGFloat(subViews.count), height: s_height)
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
        let currentIndex = self.contentOffset.x/self.frame.size.width
        self.pageViewDelegate?.scrollViewDeceleratingAction(currentIndex: Int(currentIndex))
    }
}
