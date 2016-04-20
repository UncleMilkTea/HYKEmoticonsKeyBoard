//
//  UITextView + Extension.swift
//  EmoticonsKeyBoard
//
//  Created by 侯玉昆 on 16/4/19.
//  Copyright © 2016年 suger. All rights reserved.
//

import UIKit

extension UITextView{
    
    func insertEmoticiond(emoticon:HYKEmoticons){
        
        if emoticon.type == "0" {
            
            let orginalAttr = NSMutableAttributedString(attributedString: self.attributedText)
            //这里路径不强制解包无法显示表情
            let image = UIImage(named: "\(emoticon.folderName!)/\(emoticon.png!)", inBundle: HYKEmoticonTools.sharedEmoticonTools.emoticonsBoundle, compatibleWithTraitCollection: nil)
            
            let textAttachment = HYKTextAttachment()
            
            textAttachment.emoticons = emoticon
            
            textAttachment.image = image
            
            // 设置表情图片和文字一样大小
            textAttachment.bounds = CGRectMake(0, -4, (self.font?.lineHeight)!, (self.font?.lineHeight)!)
            
            let attr = NSMutableAttributedString(attributedString: NSAttributedString(attachment: textAttachment))
            
            // 指定表情图片对应的属性文字的字体大小
            attr.addAttribute(NSFontAttributeName, value:self.font!,range:NSMakeRange(0,1))
            
            var selectRange = self.selectedRange
            
            orginalAttr.replaceCharactersInRange(selectRange, withAttributedString: attr)
            
            self.attributedText = orginalAttr
            
            selectRange.location += 1
            
            selectRange.length = 0
            
            self.selectedRange = selectRange
            
        }else{
            
            self.insertText((emoticon.code! as NSString).emoji())
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: self, userInfo: nil)
        
        self.delegate?.textViewDidChange!(self)
        
    }
    
    var emoticonText:String{
        
        get{
            
            var result = ""
            
            self.attributedText.enumerateAttributesInRange(NSMakeRange(0,self.attributedText.length), options: []) { (userInfo, range, _) -> Void in
                if let  attachment = userInfo["NSAttachment"] as? HYKTextAttachment{
                    
                    let emotion = attachment.emoticons
                    //取到表情对应的描述字符串,拼接
                    result += emotion!.chs!
                }else{
                    result += (self.attributedText.string as NSString).substringWithRange(range)
                }
            }
            return result
        }
    }
}

