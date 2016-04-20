//
//  ViewController.swift
//  EmoticonsKeyBoard
//
//  Created by 侯玉昆 on 16/4/19.
//  Copyright © 2016年 suger. All rights reserved.
//

import UIKit

/// 屏幕的宽
let SCREENW = UIScreen.mainScreen().bounds.width

class ViewController: UIViewController{
    

@IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.inputView = emoticionsKeyBoard
        
        ///监听表情按钮点击通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.emoticonButtonClick(_:)), name: EmoticionsClickBtn, object: nil)
        ///监听删除表情点击通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardDelDidSelected), name: KeyboardDelDidSelectedNotification, object: nil)
        
    }

    //MARK: - 监听表情点击
    @objc private func emoticonButtonClick(noti:NSNotification){
        
       textView.insertEmoticiond(noti.userInfo!["emoticions"]! as! HYKEmoticons)
    }
    //MARK: - 监听表情键盘的删除按钮
    @objc private func keyboardDelDidSelected(){
        
        textView.deleteBackward()
    }
    
    //MARK: - 懒加载表情键盘
    private lazy var emoticionsKeyBoard:HYKEmoticionsView = HYKEmoticionsView(frame: CGRect(x: 0, y: 0, width: SCREENW, height: 228))
    
}
