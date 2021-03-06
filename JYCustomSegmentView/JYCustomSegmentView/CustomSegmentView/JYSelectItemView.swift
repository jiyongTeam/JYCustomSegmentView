//
//  JYSelectItemView.swift
//  JYCustomSegmentView
//
//  Created by admin on 2019/9/23.
//  Copyright © 2019 Phz. All rights reserved.
//

import UIKit
/*
 * 选项标题自定义view
 */
class JYSelectItemView: UIView {

    var isSelect:Bool = false {
        didSet {
            if self.setModel.isShowSelectStaus == true {
                if isSelect == true {
                    self.titleLabel.textColor = self.setModel.textSelectColor
                    self.titleLabel.font = self.setModel.textSelectFont
                    self.backgroundColor = self.setModel.itemSelectBackGroundColor
                }else{
                    self.titleLabel.textColor = self.setModel.textNormalColor
                    self.titleLabel.font = self.setModel.textNormalFont
                    self.backgroundColor = self.setModel.itemBackGroundColor
                }
            }
        }
    }
    

    private var setModel : JYItemSetStruct = JYItemSetStruct()
    /// title
    private var titleLabel:UILabel = UILabel()
    private var actionBlock:((_ tag:Int) -> Void)?

    convenience init(option:JYItemSetStruct,title:Any) {
        self.init()
        setModel = option
        updateTitleText(text: title)
        isSelect = false
        configerUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)
    }

    @objc private func tapAction() {
        self.actionBlock?(self.tag)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
/// public API
extension JYSelectItemView {

    func tapActionBlock(block:((_ tag:Int) -> Void)?) {
         self.actionBlock = block
    }
    
    func updateTitleText(text:Any) {
        if let textStr = text as? String {
            self.titleLabel.text = textStr
        }else if let textAtt = text as? NSAttributedString {
            self.titleLabel.attributedText = textAtt
        }else {
            debugPrint("未知的数据类型")
        }
    }
    /// 获取文字大小
    func getTextRectSize() -> CGRect {
        let size = CGSize(width: 2000, height: 1000)
        if let textStr = titleLabel.text {
            let font = setModel.isShowSelectStaus == true ? setModel.textSelectFont : setModel.textNormalFont
            let attText = NSAttributedString(string: textStr, attributes: [NSAttributedString.Key.font: font])
            let rect:CGRect = attText.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
            let newRect = CGRect(x: 0, y: 0, width: rect.size.width + 1, height: rect.size.height + 1)
            return newRect
        }else if let textAtt = titleLabel.attributedText {
            let rect = textAtt.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
            let newRect = CGRect(x: 0, y: 0, width: rect.size.width + 1, height: rect.size.height + 1)
            return newRect
        }
        return CGRect.zero
    }
}
/// 布局
extension JYSelectItemView {

    private func configerUI() {
        self.backgroundColor = setModel.itemBackGroundColor
        titleLabel.textColor = setModel.textNormalColor
        titleLabel.font = setModel.textNormalFont
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[titleLabel]|", options: [], metrics: nil, views: ["titleLabel":titleLabel]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=0)-[titleLabel]-\(setModel.bottom)-|", options: [], metrics: nil, views: ["titleLabel":titleLabel]))
    }
}
