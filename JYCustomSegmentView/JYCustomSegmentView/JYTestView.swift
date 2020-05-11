//
//  JYTestView.swift
//  JYCustomSegmentView
//
//  Created by admin on 2019/8/22.
//  Copyright © 2019 Phz. All rights reserved.
//

import UIKit
/*
 * 测试view
 */
class JYTestView: UIView {

    var btn1ActionBlock:(() -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: CGFloat((arc4random() % 256)) / 255.0, green: CGFloat((arc4random() % 256)) / 255.0, blue: CGFloat((arc4random() % 256)) / 255.0, alpha: 1)
        
        let btn1 = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        btn1.backgroundColor = UIColor.brown
        btn1.setTitle("btn1点击更改数据源", for: .normal)
        btn1.addTarget(self, action: #selector(btn1Action), for: .touchUpInside)
        self.addSubview(btn1)
        
    }
    @objc private func btn1Action() {
        self.btn1ActionBlock?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
