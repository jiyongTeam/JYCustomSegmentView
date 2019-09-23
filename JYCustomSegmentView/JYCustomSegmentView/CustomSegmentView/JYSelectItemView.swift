////
////  JYSelectItemView.swift
////  JYCustomSegmentView
////
////  Created by admin on 2019/9/23.
////  Copyright © 2019 Phz. All rights reserved.
////
//
//import UIKit
//
//class JYSelectItemView: UIView {
//
//    var isSelect:Bool = false {
//        didSet {
//            if isSelect == true {
//                self.titleLabel.textColor = self.setModel.textSelectColor
//                self.titleLabel.font = self.setModel.textSelectFont
//            }else{
//                self.titleLabel.textColor = self.setModel.textNormalColor
//                self.titleLabel.font = self.setModel.textNormalFont
//            }
//        }
//    }
//    
//
//    private var setModel : JYItemSetStruct = JYItemSetStruct()
//    /// title
//    private var titleLabel:UILabel = UILabel()
//    private var actionBlock:((_ tag:Int) -> Void)?
//
//    convenience init(option:JYItemSetStruct,title:String) {
//        self.init()
//        setModel = option
//        titleLabel.text = title
//        isSelect = false
//        configerUI()
//    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = setModel.itemBackGroundColor
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
//        self.addGestureRecognizer(tap)
//    }
//
//    @objc private func tapAction() {
//        self.actionBlock?(self.tag)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
///// public API
//extension JYSelectItemView {
//
//    func tapActionBlock(block:((_ tag:Int) -> Void)?) {
//         self.actionBlock = block
//    }
//}
///// 布局
//extension JYSelectItemView {
//
//    private func configerUI() {
//        titleLabel.textAlignment = .center
//        titleLabel.backgroundColor = UIColor.yellow
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(titleLabel)
//        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[titleLabel]|", options: [], metrics: nil, views: ["titleLabel":titleLabel]))
//        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(setModel.top))-[titleLabel]-\(setModel.bottom)-|", options: [], metrics: nil, views: ["titleLabel":titleLabel]))
//    }
//}
