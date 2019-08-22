//
//  JYTestView.swift
//  JYCustomSegmentView
//
//  Created by admin on 2019/8/22.
//  Copyright © 2019 Phz. All rights reserved.
//

import UIKit

class JYTestView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: CGFloat((arc4random() % 256)) / 255.0, green: CGFloat((arc4random() % 256)) / 255.0, blue: CGFloat((arc4random() % 256)) / 255.0, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
