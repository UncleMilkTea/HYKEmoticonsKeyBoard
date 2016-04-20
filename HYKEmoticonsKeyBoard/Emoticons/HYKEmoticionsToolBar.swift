
//
//  HYKEmoticionsToolBar.swift
//  EmoticonsKeyBoard
//
//  Created by 侯玉昆 on 16/3/13.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

//MARK: - 表情类型
///
/// - Recent:  最近
/// - Default: 默认
/// - Emoji:   Emoji
/// - Lxh:     浪小花
enum HYKEmotionType: Int {
    case Recent = 0, Default, Emoji, Lxh
}
//MARK: - 表情切换代理
protocol HYKEmoticionsToolBarDelegate: NSObjectProtocol {
    
    func emoticonsToolBar(toolBar:HYKEmoticionsToolBar,type:HYKEmotionType)
}

class HYKEmoticionsToolBar: UIStackView {
    
    private var selectBtn:UIButton?
    
    weak var delegate:HYKEmoticionsToolBarDelegate?
    
    override init(frame:CGRect){
        
        super.init(frame: frame);setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    private func setupUI(){
    
        distribution = .FillEqually; tag = 1000
        
        addChildBtn("最近", backImg: "compose_emotion_table_left", type:.Recent)
        addChildBtn("默认", backImg: "compose_emotion_table_mid", type:.Default)
        addChildBtn("Emoji", backImg: "compose_emotion_table_mid", type:.Emoji)
        addChildBtn("浪小花", backImg: "compose_emotion_table_right", type:.Lxh)
    }
//MARK: - 添加子控件
    private func addChildBtn (title:String, backImg:String ,type:HYKEmotionType){
        let btn = UIButton(); btn.tag = type.rawValue
        
        // 设置文字以及不同状态下的背景图片
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "\(backImg)_normal"), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: "\(backImg)_selected"), forState: .Selected)
        
        // 设置字体大小和不同状态下的文字颜色
        btn.titleLabel?.font = UIFont.systemFontOfSize(14)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: .Selected)
        //添加事件
        btn.addTarget(self, action: #selector(HYKEmoticionsToolBar.clickToolBarBtn(_:)), forControlEvents: .TouchUpInside)
        // 添加控件
        addArrangedSubview(btn)
    }
//MARK: - 监听Toolbar按钮点击
    @objc private func clickToolBarBtn(btn:UIButton){
        
        if btn.selected == true {
            
            return
        }
        // 取到按钮的tag,生成一个枚举,并且告诉外界,我哪种类型的表情按钮点击了
        delegate?.emoticonsToolBar(self, type: HYKEmotionType(rawValue: btn.tag)!)
        
        btn.selected = true
        
        selectBtn?.selected = false
        
        selectBtn = btn
    }
//MARK: - 外界表情滚动按钮状态切换
    func selectButtonSection(section:Int){
        
        let btn = viewWithTag(section) as! UIButton
        
        if btn.selected == true {
            
            return
        }
        
        btn.selected = true
        
        selectBtn?.selected = false
        
        selectBtn = btn
    }
}
