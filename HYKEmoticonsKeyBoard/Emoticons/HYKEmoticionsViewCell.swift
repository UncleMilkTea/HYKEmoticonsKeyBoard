//
//  HYKEmoticionsViewCell.swift
//  EmoticonsKeyBoard
//
//  Created by 侯玉昆 on 16/3/13.
//  Copyright © 2016年 侯玉昆. All rights reserved.
//

import UIKit

class HYKEmoticionsViewCell: UICollectionViewCell {
    
    //给cell设置表情数据,供界设置
    var emoticions:[HYKEmoticons]?{
        
        didSet{
            
            for value in emoticionsBtnArr {
                
                value.hidden = true
            }
            for (index,emoticion) in (emoticions?.enumerate())!{
                
                let btn = emoticionsBtnArr[index]
                
                btn.hidden = false
                
                btn.emoticions = emoticion
            }
        }
    }
    
    var indexPath:NSIndexPath?{
        
        didSet{
            
            label.hidden = indexPath?.section != 0
        }
    }
    
    //MARK: - UI设置
    override init(frame: CGRect) {
        
        super.init(frame: frame); setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 布局字控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let itemW = self.frame.width/7, itemH = (self.frame.height - 20)/3
        
        for (index,button) in emoticionsBtnArr.enumerate() {
            
            let row  = CGFloat(index/7), col = CGFloat(index%7)

            button.frame = CGRectMake(col*itemW , row*itemH, itemW, itemH)
            
        }
        delButton.frame = CGRectMake(self.frame.width - itemW, 2 * itemH, itemW, itemH)
    }
    
    private func setupUI(){
        
        addEmoticionsBtn()
        
        contentView.addSubview(delButton)

        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.superview!.addConstraints([NSLayoutConstraint.init(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1, constant: 0),NSLayoutConstraint.init(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0)])
        
        
//        label.snp_makeConstraints { (make) -> Void in
//            make.centerX.bottom.equalTo(contentView)
//        }
        
        let ges = UILongPressGestureRecognizer(target: self, action: #selector(HYKEmoticionsViewCell.longPressEmoticionsBtn(_:)))
        
        addGestureRecognizer(ges)
    }

    //  添加表情按钮
    private func addEmoticionsBtn(){
        
        for _ in 0..<EveryPageCount{
            
            let btn = HYKEmoticionsButton()
            
            btn.addTarget(self, action: #selector(HYKEmoticionsViewCell.emoticionsBtnClick(_:)), forControlEvents: .TouchUpInside)
            
            btn.titleLabel?.font = UIFont.systemFontOfSize(35)
            
            contentView.addSubview(btn)
            
            emoticionsBtnArr.append(btn)
        }
    }
    //MARK: - 监听手势拖动
    @objc private func longPressEmoticionsBtn(ges:UIGestureRecognizer){
    
        func btnWithLoction (loc:CGPoint)->HYKEmoticionsButton?{
            
            for value in emoticionsBtnArr{
                
                if CGRectContainsPoint(value.frame, loc){
                    return value
                }
            }
            return nil
        }
        
        guard let btn = btnWithLoction(ges.locationInView(self)) where btn.hidden == false else{
        
            popView.removeFromSuperview()
            
            return
        }
        switch ges.state{
            
            case.Began,.Changed: UIApplication.sharedApplication().windows.last?.addSubview(popView)
        
            let rect = btn.superview!.convertRect(btn.frame, toView: window)
        
            popView.center.x = CGRectGetMidX(rect)
        
            popView.frame.origin.y = CGRectGetMaxY(rect) - popView.frame.height - 10
            
            popView.emoticionBtn.emoticions = btn.emoticions
            
        default: popView.removeFromSuperview()
            
        }
    }
    
    //MARK: - 监听表情按钮的点击
    @objc private func emoticionsBtnClick (btn:HYKEmoticionsButton){
        
        ///保存最近点击的表情按钮
        HYKEmoticonTools.sharedEmoticonTools.saveRencentEmoticons(btn.emoticions!)
        
        let window = UIApplication.sharedApplication().windows.last!
        
        window.addSubview(popView)
        
        let rect = btn.convertRect(btn.bounds, toView: window)
        
        popView.center.x = CGRectGetMidX(rect)
        
        popView.frame.origin.y = CGRectGetMaxY(rect) - popView.frame.height - 10
        
        popView.emoticionBtn.emoticions = btn.emoticions //设置数据
        
        //执行0.25秒后消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.25 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            
            self.popView.removeFromSuperview()
            
        }
        /// 表情上屏通知
        NSNotificationCenter.defaultCenter().postNotificationName(EmoticionsClickBtn, object: nil, userInfo: ["emoticions":btn.emoticions!])
    }
    //MARK: - 删除按钮点击
    @objc private func deleteButtonClick(){
        
        NSNotificationCenter.defaultCenter().postNotificationName(KeyboardDelDidSelectedNotification, object: nil)
        
    }
    
    //MARK: - 懒加载
    ///懒加载表情按钮的数组
    private lazy var emoticionsBtnArr:[HYKEmoticionsButton] = [HYKEmoticionsButton]()
    
    private lazy var popView = HYKEmoticionsPopView.popView()
    
    ///懒加载删除按钮
    private lazy var delButton:UIButton = {
       
        let btn = UIButton()
        
        btn.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
        
        btn.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
        
        btn.addTarget(self, action: #selector(HYKEmoticionsViewCell.deleteButtonClick), forControlEvents: .TouchUpInside)
        
        return btn
    }()
    ///最近使用的表情
    private lazy var label :UILabel = {
        
      let label = UILabel()
        
        label.textColor = UIColor.blackColor()
        
        label.font = UIFont.systemFontOfSize(14)

        label.text = "最近使用的表情"
        
        label.textColor = UIColor.grayColor()
        
        return label
    }()
}
