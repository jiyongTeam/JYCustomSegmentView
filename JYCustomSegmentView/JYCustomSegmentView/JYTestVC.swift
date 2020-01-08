//
//  JYTestVC.swift
//  rts
//
//  Created by admin on 2019/8/19.
//  Copyright © 2019 张冬. All rights reserved.
//

import UIKit
/*
 * 测试 VC
 */
class JYTestVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: CGFloat((arc4random() % 256)) / 255.0, green: CGFloat((arc4random() % 256)) / 255.0, blue: CGFloat((arc4random() % 256)) / 255.0, alpha: 1)
    }
}
